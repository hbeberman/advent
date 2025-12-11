const std = @import("std");
const common = @import("common.zig");
const AdventError = common.AdventError;

const Operation = enum {
    Addition,
    Multiplication,
};

const Range = struct { min: u64, max: u64 };

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u64 {
    const contents = try common.load_input(allocator, path, "day-6.txt");
    defer allocator.free(contents);
    const result = try decode(allocator, contents);
    return result;
}

fn decode(allocator: std.mem.Allocator, lines: []const u8) !u64 {
    const lines_trim = std.mem.trim(u8, lines, " \t\n\r");
    var iter = std.mem.splitSequence(u8, lines_trim, "\n");
    var total: u64 = 0;

    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    var numlines = std.ArrayList(std.ArrayList(u32)){};
    var ops: std.ArrayList(Operation) = undefined;

    while (iter.next()) |line| {
        const parse = try parse_line(
            arena.allocator(),
            line,
            &numlines,
        );
        if (parse) |*operations| {
            ops = operations.*;
        }

        //std.debug.print("\n", .{});
    }
    //std.debug.print("{any}\n", .{numlines});

    for (ops.items, 0..) |op, i| {
        //std.debug.print("i:{} {any} ", .{ i, op });
        var calc: u64 = if (op == Operation.Addition) 0 else 1;
        for (numlines.items, 0..) |numline, l| {
            if (op == Operation.Addition) {
                calc += numline.items[i];
            } else {
                calc *= numline.items[i];
            }
            _ = l;
            //std.debug.print(" {any} ", .{numline.items[i]});
        }
        total += calc;
        //std.debug.print("calc {} total {}\n", .{ calc, total });
    }

    return total;
}

fn parse_line(allocator: std.mem.Allocator, line: []const u8, numlines: *std.ArrayList(std.ArrayList(u32))) !?std.ArrayList(Operation) {
    var ops = std.ArrayList(Operation){};
    var nums = std.ArrayList(u32){};
    var iter = std.mem.tokenizeAny(u8, line, " \t\n\r");
    if (line[0] == '+' or line[0] == '*') {
        while (iter.next()) |num| {
            if (num[0] == '+') {
                try ops.append(allocator, Operation.Addition);
            } else {
                try ops.append(allocator, Operation.Multiplication);
            }
        }
        return ops;
    } else {
        while (iter.next()) |num| {
            //std.debug.print("{s} ", .{num});
            const val = std.fmt.parseInt(u32, num, 10) catch return AdventError.InvalidInput;
            try nums.append(allocator, val);
        }
        try numlines.append(allocator, nums);
        return null;
    }
}
