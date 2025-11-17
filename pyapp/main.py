from flask import Flask
import logging
from logger import init_logging

app = Flask(__name__)


def main():
    init_logging()
    log = logging.getLogger('root')

    log.debug("Logging is configured.")
    log.info("this is info message from logging")
    log.warning("this is warning message from logging")
    log.error("this is error message from logging")

@app.route('/')
def root():
    return "Hello (Python)!"


if __name__ == "__main__":
    main()
    app.run(debug=True, host="0.0.0.0", port=5000)

