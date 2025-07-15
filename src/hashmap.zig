const std = @import("std");
const stdout = std.io.getStdOut().writer();
const AutoHashMap = std.hash_map.AutoHashMap;
const StringHashMap = std.hash_map.StringHashMap;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var hash_table = AutoHashMap(u32, u16).init(allocator);
    defer hash_table.deinit();

    try hash_table.put(1, 100);
    try hash_table.put(2, 200);
    try hash_table.put(3, 300);
    try hash_table.put(4, 400);
    try hash_table.put(5, 500);

    try stdout.print("{}\n", .{hash_table.count()});
    try stdout.print("{any}\n", .{hash_table.get(1)});
    try stdout.print("{any}\n", .{hash_table.get(9)});

    // iterate hash table
    var iter = hash_table.iterator();
    while (iter.next()) |kv| {
        try stdout.print("key: {}, value: {}\n", .{ kv.key_ptr.*, kv.value_ptr.* });
    }

    var ages = StringHashMap(u8).init(allocator);
    defer ages.deinit();

    try ages.put("Pedro", 10);
    try ages.put("Matheus", 22);
    try ages.put("Abgail", 34);

    var ages_iter = ages.iterator();
    while (ages_iter.next()) |kv| {
        try stdout.print("name: {s}, age: {d}\n", .{ kv.key_ptr.*, kv.value_ptr.* });
    }
}
