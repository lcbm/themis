FROM python:3.9-slim

WORKDIR /usr/src/app

ENV PYTHONPATH=. \
  VENV=/opt/venv

RUN python3 -m venv $VENV
ENV PATH="$VENV/bin:$PATH"

COPY ./requirements.txt ./
RUN pip install -r requirements.txt

CMD ["env", "PYTHONPATH=.", "/opt/venv/bin/python", "main.py"]
