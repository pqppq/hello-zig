const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn add(x: u8, y: u8) u8 {
    return x + y;
}

fn add_and_increment(a: u8, b: u8) u8 {
    const sum = a + b;
    const inc = sum + 1;
    return inc;
}

pub fn main() !void {
    const res = add(34, 16);
    try stdout.print("Result: {d}\n", .{res});
    try stdout.print("Result: {p}\n", .{&res});
    try stdout.print("Result: {}\n", .{res});
    try stdout.print("Result: {any}\n", .{res});

    var n = add_and_increment(2, 3);
    n = add_and_increment(n, n);
    try stdout.print("n: {d}\n", .{n});
}
