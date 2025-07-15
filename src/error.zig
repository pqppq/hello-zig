const std = @import("std");
const stdout = std.io.getStdOut().writer();
const mem = std.mem;
const testing = std.testing;

pub fn main() !void {
    const dir = std.fs.cwd();
    _ = dir.openFile("does_not_exist", .{}) catch |err| {
        try stdout.print("Error: {}\n", .{err});
        return err;
    };

    if (resolvePath(std.heap.c_allocator, "/tmp/does_not_exist")) |path| {
        try stdout.print("Path: {s}\n", .{path});
    } else |err| switch (err) {
        error.OutOfMemory => try stdout.print("Out of memory\n", .{}),
        else => try stdout.print("Error: {}\n", .{err}),
    }
}

pub fn resolvePath(ally: mem.Allocator, p: []const u8) error{ OutOfMemory, CurrentWorkingDirectoryNotFound, Unexpected }![]u8 {
    // ...
    return error.OutOfMemory;
}

const A = error{ ConnectionTimedOut, DatabaseNotFound, OutOfMemory, InvalidToken };

const B = error{OutOfMemory};

fn cast(err: B) A {
    return err;
}

test "coerce error value" {
    const err = cast(B.OutOfMemory);
    try testing.expect(err == A.OutOfMemory);
}
