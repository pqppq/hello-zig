const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const expect = std.testing.expect;
const Allocator = std.mem.Allocator;

fn Stack(comptime T: type) type {
    return struct {
        items: []T,
        capacity: usize,
        length: usize,
        allocator: Allocator,

        const Self = @This();

        pub fn init(allocator: Allocator, capacity: usize) !Self {
            const buf = try allocator.alloc(T, capacity);
            return .{
                .items = buf[0..],
                .capacity = capacity,
                .length = 0,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.items);
        }

        pub fn push(self: *Self, val: T) !void {
            if ((self.length + 1) > self.capacity) {
                var new_buf = try self.allocator.alloc(T, self.capacity * 2);
                // copy items to extended buffer
                @memcpy(new_buf[0..self.capacity], self.items);
                self.allocator.free(self.items);
                self.items = new_buf;
                self.capacity = self.capacity * 2;
            }
            self.items[self.length] = val;
            self.length += 1;
        }

        pub fn pop(self: *Self) ?T {
            if (self.length == 0) return null;
            const val = self.items[self.length - 1];
            self.items[self.length - 1] = undefined;
            self.length -= 1;

            return val;
        }
    };
}

test "stack" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const StackU8 = Stack(u8);
    var stack = try StackU8.init(allocator, 3);

    try stack.push(1);
    try stack.push(2);
    try stack.push(3);
    try stack.push(4);
    try stack.push(5);

    try expect(stack.pop() == 5);
    try expect(stack.pop() == 4);
    try expect(stack.pop() == 3);
    try expect(stack.pop() == 2);
    try expect(stack.pop() == 1);
    try expect(stack.pop() == null);
    try expect(stack.pop() == null);
}
