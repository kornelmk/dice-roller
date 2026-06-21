from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class DiceType(Base):
    __tablename__ = "dice_types"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    sides = Column(Integer)