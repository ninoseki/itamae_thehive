# itamae-thehive

## Description

Automated installation of [TheHive](https://github.com/TheHive-Project/TheHive) by using [itamae](https://github.com/itamae-kitchen/itamae).

## How to use

```bash
$ itamae ssh cookbooks/hive/default.rb
```

After running this itamae script, TheHive/Cortex/Elasticsearch work on these ports.

- TheHive: `8080/tcp`
- Cortex: `9000/tcp`
- Elasticsearch: `9300/tcp`

## Notes

- [Cortex-Analyzers](https://github.com/TheHive-Project/Cortex-Analyzers) is installed to `/opt/cortex/Cortex-Analyzers`.
- This itamae script supports only Ubuntu 16.04 LTS.
