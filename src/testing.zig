const std = @import("std");
const expect = std.testing.expect;

const Allocator = std.mem.Allocator;
const expectError = std.testing.expectError;

fn some_memory_leak(allocator: Allocator) !void {
    const buf = try allocator.alloc(u32, 10);
    _ = buf;
    // return without freeing the allocated memory
}

fn alloc_error(allocator: Allocator) !void {
    var buf = try allocator.alloc(u8, 100);
    defer allocator.free(buf);
    buf[0] = 2;
}

test "simple sum" {
    const a: u8 = 2;
    const b: u8 = 2;
    const sum = a + b;

    try expect(sum == 4);
}

test "memory leak" {
    const allocator = std.testing.allocator;
    try some_memory_leak(allocator);
}

test "testing error" {
    var buf: [10]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    const allocator = fba.allocator();
    try expectError(error.OutOfMemory, alloc_error(allocator));
}

test "arrays are equal?" {
    const arr1 = [3]u32{ 1, 2, 3 };
    const arr2 = [3]u32{ 1, 2, 3 };
    try std.testing.expectEqualSlices(u32, &arr1, &arr2);
}

test "strings are equal?" {
    const str1 = "hello, world!";
    const str2 = "Hello, world!";
    try std.testing.expectEqualStrings(str1, str2);
}
