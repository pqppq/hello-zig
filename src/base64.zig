const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var memory_buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&memory_buffer);
    const allocator = fba.allocator();

    const text = "Testing some more stuff";
    const etext = "VGVzdGluZyBzb21lIG1vcmUgc3R1ZmY=";
    const base64 = Base64.init();
    const encoded_text = try base64.encode(allocator, text);
    const decoded_text = try base64.decode(allocator, etext);
    try stdout.print("Encoded text: {s}\n", .{encoded_text});
    try stdout.print("Decoded text: {s}\n", .{decoded_text});
}

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_syms = "0123456789+/";

        return Base64{
            ._table = upper ++ lower ++ numbers_syms,
        };
    }

    pub fn _char_at(self: Base64, index: usize) u8 {
        return self._table[index];
    }

    pub fn _char_index(self: Base64, char: u8) u8 {
        if (char == '=') return 64;
        var index: u8 = 0;
        for (0..63) |i| {
            if (self._table[i] == char) {
                break;
            }
            index += 1;
        }
        return index;
    }

    fn _calc_encode_length(input: []const u8) !usize {
        if (input.len < 3) {
            return 4;
        }
        const n: usize = try std.math.divCeil(usize, input.len, 3);
        return n * 4;
    }

    fn _calc_decod_length(input: []const u8) !usize {
        if (input.len < 4) {
            return 3;
        }
        const n: usize = try std.math.divFloor(usize, input.len, 4);
        var m: usize = n * 3;
        var i: usize = input.len - 1;

        while (i > 0) : (i -= 1) {
            if (input[i] == '=') {
                m -= 1;
            } else {
                break;
            }
        }
        return m;
    }

    pub fn encode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
        if (input.len == 0) {
            return "";
        }

        const n_out = try _calc_encode_length(input);
        // alloc memory
        var out = try allocator.alloc(u8, n_out);
        var buf = [3]u8{ 0, 0, 0 };
        var count: u8 = 0;
        var iout: u64 = 0;

        for (input, 0..) |_, i| {
            buf[count] = input[i];
            count += 1;
            if (count == 3) {
                out[iout] = self._char_at(buf[0] >> 2);
                out[iout + 1] = self._char_at(((buf[0] & 0x03) << 4) + ((buf[1] >> 4)));
                out[iout + 2] = self._char_at(((buf[1] & 0x0f) << 2) + ((buf[2] >> 6)));
                out[iout + 3] = self._char_at(buf[2] & 0x3f);
                iout += 4;
                count = 0;
            }
        }

        if (count == 1) {
            out[iout] = self._char_at(buf[0] >> 2);
            out[iout + 1] = self._char_at((buf[0] & 0x03) << 4);
            out[iout + 2] = '=';
            out[iout + 3] = '=';
            iout += 4;
        }
        if (count == 2) {
            out[iout] = self._char_at(buf[0] >> 2);
            out[iout + 1] = self._char_at((buf[0] & 0x03) << 4);
            out[iout + 2] = self._char_at(((buf[1] & 0x03) << 4) + (buf[1] >> 4));
            out[iout + 3] = '=';
            iout += 4;
        }

        return out;
    }

    fn decode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
        if (input.len == 0) return "";

        const n_out = try _calc_decod_length(input);
        // alloc memory
        var output = try allocator.alloc(u8, n_out);
        var count: u8 = 0;
        var iout: u64 = 0;
        var buf = [4]u8{ 0, 0, 0, 0 };

        for (0..input.len) |i| {
            buf[count] = self._char_index(input[i]);
            count += 1;
            if (count == 4) {
                output[iout] = (buf[0] << 2) + (buf[1] >> 4);
                if (buf[2] != 64) {
                    output[iout + 1] = (buf[1] << 4) + (buf[2] >> 2);
                }
                if (buf[3] != 64) {
                    output[iout + 2] = (buf[2] << 6) + buf[3];
                }
                iout += 3;
                count = 0;
            }
        }

        return output;
    }
};
