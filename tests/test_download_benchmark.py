#!/usr/bin/env python
import os
import pytest
import docker


@pytest.fixture(scope='module')
def build_dir():
    return os.path.dirname(os.path.realpath(__file__))


@pytest.fixture(scope='module')
def client():
    return docker.from_env()


@pytest.fixture(scope='module')
def image(client, build_dir):
    image, _ = client.images.build(path=build_dir, rm=True, forcerm=True)
    yield image
    client.images.remove(image=image.id)


def test_download(client, image, benchmark):
    def run():
        client.containers.run(image=image.id, remove=True)
    benchmark.pedantic(run, iterations=1, rounds=5)
