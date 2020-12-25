# https://docs.astropy.org/en/stable/coordinates/solarsystem.html

from astropy import units as u
from astropy.coordinates import EarthLocation, get_body, get_sun, solar_system_ephemeris
from astropy.time import Time
from flask import Flask, send_from_directory
import math
import os

# https://stackoverflow.com/questions/20646822/how-to-serve-static-files-in-flask
app = Flask(__name__, static_url_path="", static_folder="client")

planets = [
    "Mercury",
    "Venus",
    "Mars",
    "Jupiter",
    "Saturn",
    "Uranus",
    "Neptune",
    "Pluto",
]

current_time = Time(Time.now())
location = EarthLocation.of_site('greenwich')


def convert_km_to_light_minutes(distance):
    return (distance.to(u.lightyear).value * (1 * u.year).to(u.min)).value


def get_xyz(p):
    # Formula from: https://math.stackexchange.com/a/1273714

    (ra_hours, ra_minutes, ra_seconds) = p.ra.hms
    dec_degrees = p.dec.deg
    (_, dec_minutes, dec_seconds) = p.dec.hms

    A = (ra_hours * 15) + (ra_minutes * 0.25) + (ra_seconds * 0.004166)
    B = (abs(dec_degrees) + (dec_minutes / 60) +
         (dec_seconds / 3600)) * (1 if dec_degrees < 0 else 0)
    C = p.distance.to(u.lightyear).value

    X = (C * math.cos(B)) * math.cos(A)
    Y = (C * math.cos(B)) * math.sin(A)
    Z = C * math.sin(B)

    return (X * 1_000_000, Y * 1_000_000, Z * 1_000_000)


@app.route('/')
def show_client():
    return send_from_directory("client", "index.html")


@app.route('/info')
def get_planet_info():
    planet_info = {}
    with solar_system_ephemeris.set('de432s'):
        for planet in planets:
            p = get_body(planet, current_time, location)

            planet_info[planet] = {
                "lightMinutes": convert_km_to_light_minutes(p.distance),
                "xyz": get_xyz(p)
            }

            sun = get_sun(current_time)
            planet_info["Sol"] = {
                "lightMinutes": convert_km_to_light_minutes(sun.distance),
                "xyz": get_xyz(sun)
            }

    return planet_info


if __name__ == "__main__":
    app.run(host='0.0.0.0')
