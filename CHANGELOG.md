## 0.3.0

* Add RentSummary override attributes for bedroom and bathroom counts
```
#bedrooms_override_from_unit_type
#bathrooms_override_from_unit_type
```

If these are not set in the initialization hash, they are computed from the unit_type string as follows:
```
rs = RentSummary.new(unit_type: "4.5x2.5")
rs.bedrooms_override_from_unit_type
=> 4.5
rs.bathrooms_override_from_unit_type
=> 2.5
```

## 0.2.0 (2012-01-16)

* Moved the client_name to the configuration, since it is required
for every call to the remote service. The client_name parameter has
been removed from the method signature for all service calls, which
breaks backwards compatibility with v0.1.x.
* Added the :debug and :logger configuration options to prevent savon
from dumping all soap messages to STDOUT.
* Various minor cleanup around configuration.

## 0.1.1 (2011-06-14)

* Bug fix: explicitly namespace all require statements to avoid
collisions with other gems.

## 0.1.0 (2011-06-14)

* Initial release to rubygems.
