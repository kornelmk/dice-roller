import streamlit as st
import requests
import os

BACKEND_URL = "http://backend:8000"

st.title("Dice Roller")

dice_response = requests.get(
    f"{BACKEND_URL}/dice-types"
)

dice_types = dice_response.json()

selected = st.selectbox(
    "Typ kostki",
    dice_types,
    format_func=lambda x: x["name"]
)

count = st.number_input(
    "Ilość kostek",
    min_value=1,
    max_value=100,
    value=1
)

if st.button("Rzuć"):

    response = requests.post(
        f"{BACKEND_URL}/roll",
        json={
            "dice_id": selected["id"],
            "count": count
        }
    )

    data = response.json()

    st.subheader("Wyniki")

    st.write(data["results"])

    col1, col2 = st.columns(2)

    with col1:
        st.metric("Średnia", data["average"])
        st.metric("Minimum", data["min"])

    with col2:
        st.metric("Maksimum", data["max"])
        st.metric("Mediana", data["median"])

def get_app_version():
    try:
        response = requests.get(f"{BACKEND_URL}/version", timeout=5)
        response.raise_for_status()
        return response.json()["version"]
    except (requests.RequestException, KeyError):
        return "niedostępna"

def get_instance_id():
    return os.getenv("INSTANCE_ID", "unknown")

st.divider()
st.caption(f"Dice Roller | Wersja: {get_app_version()} | Host: {get_instance_id()} | Autor: kornelmk")