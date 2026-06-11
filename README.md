# Crusoe

[![Ruby](https://github.com/Bodacious/crusoe/actions/workflows/main.yml/badge.svg)](https://github.com/Bodacious/crusoe/actions/workflows/main.yml)

A simple daily work journal from your command-line

```
# Open today's journal and add to it
$ crusoe
```

```
crusoe help
Commands:
  crusoe help [COMMAND]  # Describe available commands or one specific command
  crusoe journal         # This is the default task.
  crusoe read            # Read an entry
  crusoe report          # Generate a report for the last week
  crusoe toc             # Update the ToC on the README.md
```

## Installation

```
TODO
```

## Feature list

### Write to journal

#### `crusoe journal ✅`

- Write a single journal entry for given day (defaults to today)
- Automatically saves to git repo configured by you
- Default command for `crusoe`
- Can provide an optional `--date` value (e.g. one of `"today"`, `"yesterday"`, `"2023-12-25"`)

#### `crusoe read ✅`

- Read a single journal entry for given day (defaults to today)
- Can provide an optional `--date` value (e.g. one of `"today"`, `"yesterday"`, `"2023-12-25"`)

#### `crusoe report ✅`

- Print the entries from the current week

#### Organise journal in the README 🏗

- WIP: Keep an up-to-date index of all entries in the README

## Development


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bodacious/crusoe.

## License

Crusoe is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
