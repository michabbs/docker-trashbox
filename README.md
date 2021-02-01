# docker-trashbox

Minimalistic public file sharing server - WWW/DAV/FTP.

Have you ever needed to quickly copy a file from one computer to another in your local network?
What if computers use different OS'es - for example one uses NFS and the other one SMB?
Or one of them is booted from live-cd and does not have any file sharing client available?

TrashBox is for you!
Simply launch it on any computer in your LAN and you immediately have public folder available!

Extremely simple. No authetication. Just open browser and use.

Note: Of course do not use it to share any private data!

## Usage (without SSL support)
```
docker run -d \
    --name trashbox \
    -p 80:80 \
    -p 21:21 -p 21000-21010:21000-21010 \
    michabbs/trashbox
```

## Usage (with SSL support)

You have to provide your own certificate:
```
docker run -d \
    --name trashbox \
    -p 80:80 -p 443:443 \
    -p 21:21 -p 21000-21010:21000-21010 \
    -v /path/to/your/cert.pem:/etc/apache2/ssl/cert.pem:ro \
    -v /path/to/your/fullchain.pem:/etc/apache2/ssl/fullchain.pem:ro \
    -v /path/to/your/privkey.pem:/etc/apache2/ssl/privkey.pem:ro \
    michabbs/trashbox
```

## Configuration (via environment variables)

Add "-e VARIABLE=value" to the above command:
- `NODAV=1` - disable WebDAV
- `NOSSL=1` - disable SSL
 Note: SSL is automatically disabled if you do not provide your own certificates (cert.pem/fullchain.pem/privkey.pem).
- `NOFTP=1` - disable FTP
- `NOPASV=1` - disable FTP passive connections (Note: some clients require PASV to be enabled!)
- `EXTERNAL_IP=x.x.x.x` - server external IP address.
 If your container is behind NAT (as they usually do) - the FTP server needs to know its external IP in order to PASV connections work correctly.
- `MIN_PORT` - minimum port number used by PASV connections (default `21000`)
- `MAX_PORT` - maximum port number used by PASV connections (default `21010`)
- `TZ=where/city` - timezone used inside container (for example `Europe/Warsaw`)

Generally you should set either EXTERNAL_IP or NOPASV, unless the container use host or macvlan networking.

## Permanent storage

Generally TrashBox is meant to be an "ad hoc" file storage, so most likely storing data in anonymous volume is enough.
Alternatively - if you really wish - you may create an permanent volume and mount it in `/srv/trashbox` folder.
Just add `-v volume_name:/srv/trashbox` or `-v /path/to/your/local/folder:/srv/trashbox` to the command line.

Of course the mount might be read only: `-v /path/to/your/local/folder:/srv/trashbox:ro` - this way you have out-of-the-box public file server!

## Access

You may access the TrashBox via:
- any web browser - just open `http://address`
- Windows Explorer - hit Win+E and write in the address field `http://address`
- Mac Finder - hit Cmd+K and write `http://address`
- any FTP client (like FileZilla) - just open `ftp://address`
- command line tools - like `wget`

Of course you may use `https` instead if `http` if SSL is enabled.
