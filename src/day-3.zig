const std = @import("std");
const common = @import("common.zig");
const AdventError = common.AdventError;

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u64 {
    const contents = try common.load_input(allocator, path, "day-3.txt");
    defer allocator.free(contents);
    const result = try decode(contents);
    return result;
}

fn decode(banks: []const u8) !u64 {
    //std.debug.print("banks:\n{s}\n", .{banks});

    const banks_trim = std.mem.trim(u8, banks, " \t\n\r");
    var iter = std.mem.splitSequence(u8, banks_trim, "\n");
    var total: u64 = 0;

    while (iter.next()) |bank| {
        total += try joltage_bank(bank, 12);
    }
    return total;
}

fn joltage_bank(bank: []const u8, digits: u8) !u64 {
    //std.debug.print("bank: {s} digits: {}\n", .{ bank, digits });

    var max: [64]u8 = .{0} ** 64;

    for (0..bank.len) |bank_pos| {
        try decide_switch(&max, bank, bank_pos, digits);
    }

    var buf: [64]u8 = undefined;
    const num = try std.fmt.bufPrint(&buf, "{s}", .{max});
    //std.debug.print("num:{s}\n", .{num});
    const joltage = try std.fmt.parseInt(u64, num[0..digits], 10);

    return joltage;
}

fn decide_switch(max: []u8, bank: []const u8, bank_pos: usize, digits: u8) !void {
    //std.debug.print("switch:{c}\n", .{bank[bank_pos]});
    for (0..digits) |max_pos| {
        //std.debug.print("{d}:{x}\n", .{ max_pos, max[max_pos] });
        if ((bank.len - bank_pos) < digits - max_pos) {
            //std.debug.print("SKIP {d}\n", .{max_pos});
            continue;
        }
        const bank_val = bank[bank_pos];
        if (bank_val > max[max_pos]) {
            max[max_pos] = bank_val;
            @memset(max[max_pos + 1 ..], 0);
            //std.debug.print("GRAB {d}:{c}\n", .{ max_pos, max[max_pos] });
            return;
        }
    }
}
