const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const expect = std.testing.expect;

pub fn main() !void {
    var buf: [5]u8 = .{ 0, 0, 0, 0, 0 };
    _ = try stdout.write("Please write a 4-digit integer number\n");
    _ = try stdin.readUntilDelimiter(&buf, '\n');

    try stdout.print("Input: {any}\n", .{buf});
    // this value is only known at runtime!
    const n: u32 = try std.fmt.parseInt(u32, buf[0 .. buf.len - 1], 10);

    const twice_result = twice(n);
    try stdout.print("Twice: {}\n", .{twice_result});
}

// fn twice(comptime num: u32) u32 {
fn twice(num: u32) u32 {
    return num * 2;
}

fn fibonacci(index: u32) u32 {
    if (index < 2) return  index;
    return fibonacci(index - 1) + fibonacci(index - 2);
}

fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}

test "test comptime" {
    _ = twice(5678);
}


test "fibonacci" {
    try expect(fibonacci(0) == 0);
    try expect(fibonacci(1) == 1);
    try expect(fibonacci(7) == 13);
    try comptime expect(fibonacci(7) == 13);
}

test "max" {
    const n1 = max(u8, 4, 8);
    try expect(n1 == 8);
    const n2 = max(u32, 10, 9);
    try expect(n2 == 10);
}
