import flask
from backend import app
from backend.services.extended_lands import get_extended_land_by_id, serialize_extended_lands


@app.route("/api/extended_lands/<int:land_oid>")
def get_extended_land_controller(land_oid):
    data_json = serialize_extended_lands((get_extended_land_by_id(land_oid=land_oid), ))[0]
    response = flask.make_response(data_json, 200)
    response.headers["Content-Type"] = "application/json"
    return response
