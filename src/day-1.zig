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

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u16 {
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
    try test_path.appendSlice(allocator, "day-1.txt");

    const file = try std.fs.openFileAbsolute(test_path.items, .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, 100_000);
    defer allocator.free(contents);
    const result = try decode(contents);
    return result;
}

fn decode(steps: []const u8) !u16 {
    var iterator = std.mem.splitSequence(u8, steps, "\n");

    var step: Step = undefined;
    var pos: u16 = 50;
    var password: u16 = 0;

    while (iterator.next()) |line| {
        step = try validate_line(line) orelse continue;

        password += step.clicks / 100;

        const clicks = step.clicks % 100;
        switch (step.dir) {
            Direction.left => {
                if (pos < clicks and pos != 0) {
                    password += 1;
                }
                pos = @mod(pos + 100 - clicks, 100);
            },
            Direction.right => {
                if (pos + clicks > 100 and pos != 0) {
                    password += 1;
                }
                pos = @mod(pos + clicks, 100);
            },
        }
        if (pos == 0) {
            password += 1;
        }
        //std.debug.print("step: {} pos:{} pass:{}\n", .{ step, pos, password });
    }
    return password;
}

fn validate_line(line: []const u8) !?Step {
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
