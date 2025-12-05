const std = @import("std");
const ArrayList = std.ArrayList;

const Direction = enum {
    left,
    right,
};

const Step = struct {
    clicks: u16,
    dir: Direction,
};

const AdventError = error{
    InvalidTestInput,
};

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !void {
    std.debug.print("Day 1: Secret Entrance!\n", .{});

    var test_path: ArrayList(u8) = .empty;
    defer test_path.deinit(allocator);

    // prepend cwd if path is relative
    if (std.fs.path.isAbsolute(path)) {
        std.debug.print("Path {s} is absolute\n", .{path});
    } else {
        std.debug.print("Path {s} is not absolute\n", .{path});
        var buf: [std.fs.max_path_bytes]u8 = undefined;
        const cwd_path = try std.process.getCwd(&buf);
        try test_path.appendSlice(allocator, cwd_path);
        try test_path.append(allocator, '/');
    }
    // prepare the rest of path
    try test_path.appendSlice(allocator, path);
    try test_path.appendSlice(allocator, "day-1.txt");
    std.debug.print("test_path {s}\n", .{test_path.items});

    const file = try std.fs.openFileAbsolute(test_path.items, .{});
    defer file.close();
    std.debug.print("file {}\n", .{file});

    const contents = try file.readToEndAlloc(allocator, 100_000);
    defer allocator.free(contents);
    std.debug.print("{s}", .{contents});
    _ = try decode(contents);
}

fn decode(steps: []const u8) !u16 {
    var iterator = std.mem.splitSequence(u8, steps, "\n");

    var step: Step = undefined;

    while (iterator.next()) |line| {
        step = try validate_line(line) orelse continue;
        std.debug.print("step {}\n", .{step});
    }
    return 0;
}

fn validate_line(line: []const u8) !?Step {
    std.debug.print("line {s}\n", .{line});
    switch (line.len) {
        0 => {
            return null;
        },
        2...4 => {},
        else => {
            return AdventError.InvalidTestInput;
        },
    }

    const dir = switch (line[0]) {
        'L' => Direction.left,
        'R' => Direction.right,
        else => {
            return AdventError.InvalidTestInput;
        },
    };

    const clicks = try std.fmt.parseInt(u16, line[1..], 10);

    return Step{
        .clicks = clicks,
        .dir = dir,
    };
}
