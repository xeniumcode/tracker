import logging.config
import os

os.makedirs("logs", exist_ok=True)

LOGGING_CONFIG = {
    "version": 1,
    "disable_existing_loggers": False,  # else it will create issue for fastapi
    "formatters": {
        "default": {
            "format": "%(asctime)s - %(levelname)s - %(name)s - %(message)s",
        },
        "detailed": {
            "format": "%(asctime)s - %(levelname)s - %(name)s "
            "[%(filename)s:%(lineno)d] - %(message)s",
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "default",
        },
        "file": {
            "class": "logging.FileHandler",
            "filename": "logs/app.log",
            "formatter": "detailed",
        },
    },
    "root": {
        "level": "ERROR",
        "handlers": ["file"],
    },
}


def setup_logging():
    logging.config.dictConfig(LOGGING_CONFIG)
