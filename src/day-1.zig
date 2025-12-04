const std = @import("std");
const ArrayList = std.ArrayList;

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !void {
    std.debug.print("Day 1: Secret Entrance!\n", .{} );

    var test_path: ArrayList(u8) = .empty;
    defer test_path.deinit(allocator);

    // prepend cwd if path is relative
    if (std.fs.path.isAbsolute(path)) {
        std.debug.print("Path {s} is absolute\n", .{path} );
    } else {
        std.debug.print("Path {s} is not absolute\n", .{path} );
        var buf: [std.fs.max_path_bytes]u8 = undefined;
        const cwd_path = try std.process.getCwd(&buf);
        try test_path.appendSlice(allocator, cwd_path);
        try test_path.append(allocator, '/');
    }
    // prepare the rest of path
    try test_path.appendSlice(allocator, path);
    try test_path.appendSlice(allocator, "day-1.txt");
    std.debug.print("test_path {s}\n", .{test_path.items} );

    const file = try std.fs.openFileAbsolute(test_path.items, .{});
    defer file.close();
    std.debug.print("file {}\n", .{file} );

    const contents = try file.readToEndAlloc(allocator, 100_000);
    std.debug.print("{s}", .{contents} );
    defer allocator.free(contents);
}
