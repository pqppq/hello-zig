const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var number: u8 = 5;
    const pointer = &number;

    pointer.* += 1;
    try stdout.print("number: {d}\n", .{number});

    const doubled = 2 * pointer.*;

    try stdout.print("doubled: {d}\n", .{doubled});

    const arr = [_]i32{ 1, 2, 3, 4, 5, 6 };
    var ptr: [*]const i32 = &arr;
    try stdout.print("ptr: {d}\n", .{ptr[0]});
    ptr += 1;
    try stdout.print("ptr: {d}\n", .{ptr[0]});
    ptr += 1;
    try stdout.print("ptr: {d}\n", .{ptr[0]});
    ptr += 1;
    try stdout.print("ptr: {d}\n", .{ptr[0]});
    ptr += 1;
    try stdout.print("ptr: {d}\n", .{ptr[0]});
    ptr += 1;
    try stdout.print("ptr: {d}\n", .{ptr[0]});
    ptr += 1;
    try stdout.print("ptr: {d}\n", .{ptr[0]});
    try stdout.print("arr: {any}\n", .{arr});

    const p: ?u8 = null;
    const r = incr(p);
    _ = r;

    const x: ?u8 = null;
    if (x) |value| {
        std.debug.print("x: {d}\n", .{value});
    } else {
        std.debug.print("x: null\n", .{});
    }
}

pub fn incr(v: ?u8) u8 {
    if (v) |unpacked| {
        return unpacked + 1;
    }
    return 0;
}
