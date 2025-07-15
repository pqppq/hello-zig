const std = @import("std");
const math = std.math;

pub fn main() !void {
    std.debug.print("foo.zig", .{});

    var age: u8 = undefined;
    // age = 25;
    age += 2;
    // age = null;
    std.debug.print("age is {d}\n", .{age});
    const i: u32 = @intFromFloat(1.00);
    _ = i;

    const ns = [4]u8{ 1, 2, 3, 4 };
    const ls = [_]f64{ 1, 3, 4, 5 };
    // discard value
    _ = ns;
    std.debug.print("ls is {d}\n", .{ls});

    const a: u8 = 100;

    label: {
        // const b: u8 = 101; // block scope variable
        std.debug.print("a is {d}\n", .{a});

        break :label;
    }
    std.debug.print("b is {d}\n", .{a});

    const str = "This is an example of string literal in Zig";
    std.debug.print("{s}\n", .{str});
    std.debug.print("{s}\n", .{str[0..9]});

    for (str) |c| {
        // to upper
        std.debug.print("{c}", .{std.ascii.toUpper(c)});
    } else std.debug.print("\n", .{});

    const string_object = "Ⱥ";
    const stdout = std.io.getStdOut().writer();
    for (string_object) |c| {
        try stdout.print("{X} ", .{c});
    }

    std.debug.print("type of str is {}\n", .{@TypeOf(str)});
    defer std.debug.print("type of string_object is {}\n", .{@TypeOf(string_object)});

    var utf8 = try std.unicode.Utf8View.init("牛丼並盛２８０円");
    var iter = utf8.iterator();
    while (iter.nextCodepointSlice()) |codepoint| {
        std.debug.print("{s}\n", .{codepoint});
    }

    const Role = enum { SE, DPE, DE, DA, PM, PO, KS };
    const role = Role.SE;
    xsw: switch (role) {
        .SE => {
            std.debug.print("continue block\n", .{});
            continue :xsw Role.DE;
        },
        .DPE, .DE, .DA => {
            std.debug.print("DPE or DE or DA\n", .{});
        },
        else => {
            std.debug.print("else\n", .{});
        },
    }

    {
        try foo();
        errdefer std.debug.print("foo error", .{});
    }

    var x: u8 = 1;
    const p = &x;
    p.* = p.* + 1;

    const user = User.init(1, "pqppq", "pqppqhogehoge.com");
    _ = user;

    var anonymous = User{ .id = 1, .name = "fasdfad", .email = "fasdfasd" };
    anonymous.name = "fasdfasdfasdfasdf";
    // _ = anonymous;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);
    some_number.* = @as(u32, 45);
}

fn foo() !void {
    return error.FooError;
}

const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,
    fn init(id: u64, name: []const u8, email: []const u8) User {
        return User{ .id = id, .name = name, .email = email };
    }
};
