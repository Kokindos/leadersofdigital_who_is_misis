import os

import flask
from backend import app

@app.route("/api/heatmap/<int:number_of_sections>")
def heatmap_controller(number_of_sections):
    filename = os.path.join(app.config["PREPROCESSED_DATA_PATH"], f"heatmap_{number_of_sections}.json")
    if not os.path.exists(filename):
        return flask.abort(404)

    with open(filename) as f:
        r = flask.make_response(f.read())
        r.headers["Content-Type"] = "application/json"
        return r
