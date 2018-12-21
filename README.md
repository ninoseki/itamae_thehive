# itamae-thehive

## Description

Automated installation of [TheHive](https://github.com/TheHive-Project/TheHive) & [Cortex](https://github.com/TheHive-Project/Cortex) by using [itamae](https://github.com/itamae-kitchen/itamae).

## Supported versions

- OS: `Ubuntu 16.04 LTS`
- TheHive: `3.2.1`
- Cortex: `2.1.3`

## Prerequisite

Please install itamae beforehand.

```bash
$ gem install itamae
```

## How to use

```bash
# Apply an itamae recipe to a Vagrant VM
$ itamae ssh --vagrant cookbooks/thehive/default.rb
# Apply an itamae recipe to a remote host
$ itamae ssh --host x.x.x.x cookbooks/thehive/default.rb
```

After running the itamae recipe, TheHive / Cortex / Elasticsearch work on following ports.

- TheHive: `9000/tcp`
- Cortex: `9001/tcp`
- Elasticsearch: `9300/tcp`

## Configuration

### Setting up Cortex

Go to `http://YOUR_SERVER_ADDRESS:9001` and follow instructions of [the official guide](https://github.com/TheHive-Project/CortexDocs/blob/master/admin/quick-start.md#step-2-update-the-database).

### Setting up TheHive

You need to set your Cortex API key in `/etc/thehive/application.conf`.

```
cortex {
  "CORTEX-SERVER-ID" {
    url = "http://localhost:9001"
    key = "YOUR_API_KEY"
  }
}
```

And then go to `http://YOUR_SERVER_ADDRESS:9000` and follow instructions of [the official guide](https://github.com/TheHive-Project/TheHiveDocs/blob/master/installation/install-guide.md#5-first-start).

## Notes

- [Cortex-Analyzers](https://github.com/TheHive-Project/Cortex-Analyzers) is installed into `/opt/cortex/Cortex-Analyzers`.

## References

- [TheHive-Project/CortexDocs](https://github.com/TheHive-Project/CortexDocs)
- [TheHive-Project/TheHiveDocs](https://github.com/TheHive-Project/TheHiveDocs)
