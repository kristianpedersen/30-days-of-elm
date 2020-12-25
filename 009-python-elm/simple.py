from astropy import units as u
from astropy.time import Time
from astropy.coordinates import solar_system_ephemeris, EarthLocation
from astropy.coordinates import get_body

t = Time("2014-09-22 23:22")
loc = EarthLocation.of_site('greenwich')

with solar_system_ephemeris.set('builtin'):
    jup = get_body('jupiter', t, loc)

    print(jup.distance)
    print(jup.distance.to(u.lightyear))
    print(jup.distance.to(u.lightyear) * (1 * u.year).to(u.min))
    print(jup.distance.to(u.lightyear).value * (1 * u.year).to(u.min).value)
