# itamae-thehive

## Description

Automated installation of [TheHive](https://github.com/TheHive-Project/TheHive) & [Cortex](https://github.com/TheHive-Project/Cortex) by using [itamae](https://github.com/itamae-kitchen/itamae).

## How to use

```bash
# Apply an itamae recipe to a Vagrant VM
$ itamae ssh --vagrant cookbooks/hive/default.rb
# Apply an itamae recipe to a remote host
$ itamae ssh --host x.x.x.x cookbooks/hive/default.rb
```

After running the itamae recipe, TheHive / Cortex / Elasticsearch work on these ports.

- TheHive: `8080/tcp`
- Cortex: `9001/tcp`
- Elasticsearch: `9300/tcp`

## Notes

- This itamae script supports only Ubuntu 16.04 LTS.
- [Cortex-Analyzers](https://github.com/TheHive-Project/Cortex-Analyzers) is installed to `/opt/cortex/Cortex-Analyzers`.
- You need to upload a report template of Cortex manually. Please refer to `6. Cortex` of [TheHiveDocs/admin/configuration.md](https://github.com/TheHive-Project/TheHiveDocs/blob/master/admin/configuration.md#6-cortex)
- You need to create a Cortex account for TheHive integration and set its API key in `/ /etc/thehive/application.conf` manually.
