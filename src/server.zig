const std = @import("std");
const builtin = @import("builtin");

const net = std.net;
const posix = std.posix;

const stdout = std.io.getStdOut().writer();

pub const Socket = struct {
    _address: net.Address,
    _stream: net.Stream,

    pub fn init() !Socket {
        const host = [4]u8{ 127, 0, 0, 1 };
        const port = 3490;
        const addr = net.Address.initIp4(host, port);

        const socket = try posix.socket(addr.any.family, posix.SOCK.STREAM, posix.IPPROTO.TCP);
        const stream = net.Stream{ .handle = socket };
        return Socket{ ._address = addr, ._stream = stream };
    }
};

const Connection = net.Server.Connection;

pub fn read_request(conn: Connection, buffer: []u8) !void {
    const reader = conn.stream.reader();
    _ = try reader.read(buffer);
}

const Map = std.static_string_map.StaticStringMap;
const MethodMap = Map(Method).initComptime(.{ .{ "GET", Method.GET }, .{ "POST", Method.POST } });

pub const Method = enum {
    GET,
    POST,

    pub fn init(text: []const u8) !Method {
        return MethodMap.get(text).?;
    }
    pub fn is_supported(m: []const u8) bool {
        const method = MethodMap.get(m);
        if (method) |_| {
            return true;
        }
        return false;
    }
};

const Request = struct {
    method: Method,
    version: []const u8,
    uri: []const u8,

    pub fn init(method: Method, uri: []const u8, version: []const u8) Request {
        return Request{ .method = method, .uri = uri, .version = version };
    }
};

pub fn parse_request(text: []u8) Request {
    const line_index = std.mem.indexOfScalar(u8, text, '\n') orelse text.len;
    var iter = std.mem.splitScalar(u8, text[0..line_index], ' ');
    const method = try Method.init(iter.next().?);

    const uri = iter.next().?;
    const version = iter.next().?;
    const request = Request.init(method, uri, version);

    return request;
}

pub fn send_200(conn: Connection) !void {
    const message = ("HTTP/1.1 200 OK\nContent-Length: 48" ++ "\nContent-Type: text/html\n" ++ "Connection: Closed\n\n<html><body>" ++ "<h1>Hello, World!</h1></body></html>");
    _ = try conn.stream.write(message);
}

pub fn send_404(conn: Connection) !void {
    const message = ("HTTP/1.1 404 Not Found\nContent-Length: 50" ++ "\nContent-Type: text/html\n" ++ "Connection: Closed\n\n<html><body>" ++ "<h1>File not found!</h1></body></html>");
    _ = try conn.stream.write(message);
}

pub fn main() !void {
    const socket = try Socket.init();
    try stdout.print("Server Address: {any}\n", .{socket._address});
    var server = try socket._address.listen(.{});
    const connection = try server.accept();

    var buf: [1000]u8 = undefined;
    for (0..buf.len) |i| {
        buf[i] = 0;
    }

    try read_request(connection, buf[0..buf.len]);
    const request = parse_request(buf[0..buf.len]);
    try stdout.print("Request: {any}\n", .{request});

    if (request.method == Method.GET) {
        try send_200(connection);
    } else {
        try send_404(connection);
    }
}
