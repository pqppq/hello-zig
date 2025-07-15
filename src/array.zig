const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buf = try std.ArrayList(u8).initCapacity(allocator, 100);
    defer buf.deinit();
    try buf.append(1);
    try buf.append(2);
    try buf.append(3);

    for (0..10) |i| {
        const v: u8 = @intCast(i);
        try buf.append(v);
    }

    try stdout.print("{any}\n", .{buf.items});

    _ = buf.orderedRemove(0);
    _ = buf.orderedRemove(0);
    try stdout.print("{any}\n", .{buf.items});
    try stdout.print("{any}\n", .{buf.items.len});

    try buf.insert(0, 100);
    try stdout.print("{any}\n", .{buf.items});

    // loop array
    for (buf.items) |v| {
        try stdout.print("{}\n", .{v});
    }
}
