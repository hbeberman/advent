const std = @import("std");
const ArrayList = std.ArrayList;

pub fn load_input(allocator: std.mem.Allocator, path: [:0]const u8, filename: []const u8) ![]u8 {
    var test_path: ArrayList(u8) = .empty;
    defer test_path.deinit(allocator);

    // prepend cwd if path is relative
    if (!std.fs.path.isAbsolute(path)) {
        var buf: [std.fs.max_path_bytes]u8 = undefined;
        const cwd_path = try std.process.getCwd(&buf);
        try test_path.appendSlice(allocator, cwd_path);
        try test_path.append(allocator, '/');
    }
    // prepare the rest of path
    try test_path.appendSlice(allocator, path);
    try test_path.append(allocator, '/');
    try test_path.appendSlice(allocator, filename);

    const file = std.fs.openFileAbsolute(test_path.items, .{}) catch |err| {
        switch (err) {
            error.FileNotFound => std.debug.print("File not found: {s}\n", .{test_path.items}),
            error.AccessDenied => std.debug.print("Access denied {s}\n", .{test_path.items}),
            else => std.debug.print("Unable to open file {s}: {}\n", .{ test_path.items, err }),
        }
        return err;
    };
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, 100_000);
    return contents;
}
