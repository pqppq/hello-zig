const std = @import("std");
const stdout = std.io.getStdOut().writer();


pub fn main() !void {
    const v1 = @Vector(4, u32){ 1,2,3,4 };
    const v2 = @Vector(4, u32){ 2,3,4,5 };
    const v3 = v1 + v2;
    const v4: @Vector(10, u32) = @splat(16);

    try stdout.print("vector: {any}\n", .{v3});
    try stdout.print("vector: {any}\n", .{v4});
}
