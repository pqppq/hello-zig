const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;

fn do_some_work(n: *const u8) !void {
    _ = try stdout.print("Start working {}!\n", .{n.*});
    std.time.sleep(100 * std.time.ns_per_ms);
    _ = try stdout.print("Done working {}!\n", .{n.*});
}


pub fn main() !void {
    const n1: u8 = 1;
    const n2: u8 = 2;
    const n3: u8 = 3;
    const thread1 = try Thread.spawn(.{}, do_some_work, .{&n1});
    const thread2 = try Thread.spawn(.{}, do_some_work, .{&n2});
    const thread3 = try Thread.spawn(.{}, do_some_work, .{&n3});

    thread3.join();
    thread2.join();
    thread1.join();
}
