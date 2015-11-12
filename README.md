##Preview

![](https://raw.githubusercontent.com/peelman/dashing-puppet/master/puppetdb-preview.png)

## Description

This is a [Dashing](http://shopify.github.com/dashing) widget to display basic statistics from [PuppetDB](http://docs.puppetlabs.com/puppetdb/latest) 3.2.

##Usage

To use this widget, copy `puppetdb_stats.html`, `puppetdb_stats.coffee`, and `puppetdb_stats.scss` into a `/widgets/puppetdb` directory, and copy the `puppetdb_stats.rb` file into your `/jobs` folder.


To include the widget in a dashboard, add the following snippet to the dashboard layout file:


```html
	<li data-row="2" data-col="2" data-sizex="3" data-sizey="3">
		<div data-id="puppetdb_stats" data-view="PuppetdbStats"></div>
	</li>
```

##Settings

* **Host**: You need to set the host to the hostname of your puppetDB server
* **Port**: You need to set the port to the HTTP or HTTPS port of your puppetDB server
* **unreported_delay**: Defaults to 3600 seconds (one hour)
* **use_ssl**: Set to true to enable SSL
* **host_cert**: Set to the path to the SSL cert (assuming the machine hosting your dashboards is managed by puppet)
* **host_key**: Set to the path to the SSL key (see host\_cert)

## Credits

Based mostly upon [this gist](https://gist.github.com/bitflingr/a49981b299dff184c04a) by [bitflingr](http://github.com/bitflingr).