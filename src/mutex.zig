const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;
const Mutex = std.Thread.Mutex;

var counter : usize = 0;

fn increment(mutex: *Mutex) void {
    for (0..10000) |_|  {
        mutex.lock(); // acquire lock
        counter += 1;
        mutex.unlock(); // free lock
    }
}

pub fn main() !void {
    var mutex: Mutex = .{};
    const incr_thread1 = try Thread.spawn(.{}, increment, .{&mutex});
    const incr_thread2 = try Thread.spawn(.{}, increment, .{&mutex});

    incr_thread1.join();
    incr_thread2.join();
    _ = try stdout.print("Counter: {}\n", .{counter});
}
