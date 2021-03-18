final int WIDTH_SIZE_SLOT = 113;
final int HEIGHT_SIZE_SLOT = 113;
public final class InventoryScreen {
  int delay;
  boolean isGrabItem = false;
  Item currentItem;
  Weapon currentWeapon;
  Slot origin;
  Slot destination;
  //ORigin https://www.deviantart.com/bizmasterstudios
  Slot[][] imageSlots;
  ArrayList<Item> items;
  ArrayList<Weapon> weapons;
  PImage backgroundImage;
  public InventoryScreen(PImage backgroundImage) {
    imageSlots = new Slot[5][3]; //x, y Usually otherway round, but program this way to visualise easier.
    this.backgroundImage = backgroundImage;
    for (int i=0; i < imageSlots.length; i++) {
      for (int j = 0; j < imageSlots[0].length; j++) {
        imageSlots[i][j] = new Slot();
        imageSlots[i][j].x = (91+(i * 176));
        imageSlots[i][j].y = 505 + (j * 149);
      }
    }
  }

  private class Slot {
    boolean isTaken;
    Item item;
    Weapon weapon;
    int x;
    int y;
    boolean optionActive;
  }



  public void showInventory(Player player) {
    image(backgroundImage, 0, 0);
    for (int i=0; i < imageSlots.length; i++) {
      for (int j = 0; j < imageSlots[0].length; j++) {
        if (imageSlots[i][j].isTaken) {
          if (imageSlots[i][j].item!=null)image(imageSlots[i][j].item.inventoryView, imageSlots[i][j].x, imageSlots[i][j].y);
          else image(imageSlots[i][j].weapon.inventoryView, imageSlots[i][j].x, imageSlots[i][j].y);
        }
      }
    }
    showDisplay();
    dragPressed();
    dragReleased();
    onClickSlot();
    onCheckBox(player);
    showStats(player);
  }

  public void addItem(Item item) {
    for (int i=0; i < imageSlots.length; i++) {
      for (int j = 0; j < imageSlots[0].length; j++) {
        if (!imageSlots[i][j].isTaken) {
          imageSlots[i][j].isTaken = true;
          imageSlots[i][j].item = item;
          return;
        }
      }
    }
  }
  public void addWeapon(Weapon weapon) {
    for (int i=0; i < imageSlots.length; i++) {
      for (int j = 0; j < imageSlots[0].length; j++) {
        if (!imageSlots[i][j].isTaken) {
          imageSlots[i][j].weapon = weapon;
          imageSlots[i][j].isTaken = true;
          return;
        }
      }
    }
  }

  private void showDisplay() {
    for (int i=0; i < imageSlots.length; i++) {
      for (int j = 0; j < imageSlots[0].length; j++) {
        if (imageSlots[i][j].isTaken) {
          if (isSlotHover(imageSlots[i][j])) {
            textSize(12);
            fill(153, 153, 153, 190);
            rect(imageSlots[i][j].x, imageSlots[i][j].y - 50, 400, 50);
            fill(255);
            if (isItemSlot(imageSlots[i][j])) {
              text(imageSlots[i][j].item.description, imageSlots[i][j].x + 5, imageSlots[i][j].y-25);
              text("Value Changes: " + imageSlots[i][j].item.value, imageSlots[i][j].x + 5, imageSlots[i][j].y-10);
            } else {
              text(imageSlots[i][j].weapon.description, imageSlots[i][j].x + 5, imageSlots[i][j].y-25);
              text("Damage:" + imageSlots[i][j].weapon.damage, imageSlots[i][j].x + 5, imageSlots[i][j].y-10);
            }
          }
          if (imageSlots[i][j].optionActive) {
            fill(150, 190);
            rect(imageSlots[i][j].x, imageSlots[i][j].y-50, 113, 50);
            fill(130, 210);
            rect(imageSlots[i][j].x, imageSlots[i][j].y-45, 60, 40);
            rect(imageSlots[i][j].x + 55, imageSlots[i][j].y-45, 60, 40);
            fill(255);
            textSize(15);
            text("Equip", imageSlots[i][j].x + 5, imageSlots[i][j].y -35);
            text("Drop", imageSlots[i][j].x + 55, imageSlots[i][j].y - 35);
          }
        }
      }
    }
  }

  public boolean isSlotHover(Slot slot) {
    return(mouseX > slot.x && mouseX < (slot.x + WIDTH_SIZE_SLOT) && mouseY > slot.y && mouseY < (slot.y + HEIGHT_SIZE_SLOT));
  }

  public boolean isItemSlot(Slot slot) {
    return slot.item!=null;
  }

  void onClickSlot() {
    if (mousePressed == true && mouseButton == RIGHT && processTime(1)) {
      for (int i=0; i < imageSlots.length; i++) {
        for (int j = 0; j < imageSlots[0].length; j++) {
          if (isSlotHover(imageSlots[i][j]) && imageSlots[i][j].isTaken) {
            imageSlots[i][j].optionActive = !imageSlots[i][j].optionActive;
            delay = millis();
          }
        }
      }
    }
  } 

  void onCheckBox(Player player) {
    int removeX = -1;
    int removeY = -1;
    for (int i=0; i < imageSlots.length; i++) {
      for (int j = 0; j < imageSlots[0].length; j++) {
        if (imageSlots[i][j].optionActive) {
          if (mousePressed == true && mouseButton == LEFT && processTime(1)) {
            if (mouseX > imageSlots[i][j].x && mouseX < imageSlots[i][j].x + WIDTH_SIZE_SLOT/2  && mouseY > imageSlots[i][j].y-45 && mouseY < imageSlots[i][j].y-5) {
              if (isItemSlot(imageSlots[i][j])) {
                if (imageSlots[i][j].item.isConsumable) {
                  removeX= i;
                  removeY = j;
                  if (imageSlots[i][j].item.isStatChanger) {
                    int randomStat = (int) random(0, 6);
                    System.out.println(randomStat);
                    switch(randomStat) {
                    case 0: 
                      {
                        player.maxHealth++;
                        break;
                      }
                    case 1: 
                      {
                        player.attackPower++;
                        break;
                      }
                    case 2: 
                      {
                        player.defense++;
                        break;
                      }
                    case 3: 
                      {
                        player.specialAttack++;
                        break;
                      }
                    case 4: 
                      {
                        player.specialDefense++;
                        break;
                      }
                    case 6: 
                      {
                        player.speed++;
                        break;
                      }
                    }
                    //change stat.
                  } else {
                    //change health 
                    if(!imageSlots[i][j].item.name.equals("Armor")){
                    player.health += imageSlots[i][j].item.value;
                    if (player.health > player.maxHealth) player.health = player.maxHealth;
                    }else{
                      player.armor += imageSlots[i][j].item.value;
                    }
                  }
                }
              } else {
                if(imageSlots[i][j].weapon.name.equals("Spellbook")){
                  //Add the move onto the the last move.
                }
                //Is weapon. Just equip.
                player.weapon = imageSlots[i][j].weapon;
                //TODO: Have option to unequip as well.
              }
            } else if (mouseX > (imageSlots[i][j].x + (WIDTH_SIZE_SLOT/2) + 1) + 1 && mouseX < imageSlots[i][j].x + WIDTH_SIZE_SLOT && mouseY > imageSlots[i][j].y-45 && mouseY < imageSlots[i][j].y-5) {
              //DISCARD.
              removeX = i;
              removeY = j;
            }
          }
        }
      }
    }
    if (removeX != -1 && removeY!= -1) {
      imageSlots[removeX][removeY].isTaken = false;
      imageSlots[removeX][removeY].item = null;
      imageSlots[removeX][removeY].weapon = null;
      imageSlots[removeX][removeY].optionActive = false;
    }
  }







  void dragPressed() {
    if (mousePressed == true && !isGrabItem && mouseButton == LEFT) {
      currentItem = null;
      currentWeapon = null;
      for (int i=0; i < imageSlots.length; i++) {
        for (int j = 0; j < imageSlots[0].length; j++) {
          if (imageSlots[i][j].isTaken) {
            if (isSlotHover(imageSlots[i][j])) {
              origin = imageSlots[i][j];
              isGrabItem = true;
              if (isItemSlot(imageSlots[i][j])) {
                currentItem = imageSlots[i][j].item;
              } else {
                currentWeapon = imageSlots[i][j].weapon;
              }
            }
          }
        }
      }
    }
    if (isGrabItem) {
      if (isItemSlot(origin)) image(origin.item.inventoryView, mouseX, mouseY);
      else image(origin.weapon.inventoryView, mouseX, mouseY);
    }
  }



  void dragReleased() {
    if (mousePressed==false) {
      if (isGrabItem) {
        isGrabItem = false;
        for (int i=0; i < imageSlots.length; i++) {
          for (int j = 0; j < imageSlots[0].length; j++) {
            if (isSlotHover(imageSlots[i][j])) {
              destination = imageSlots[i][j];
              if (imageSlots[i][j].isTaken) {
                //REplace Item
                if (isItemSlot(imageSlots[i][j])) {
                  if (currentItem != null) {
                    Item temp = destination.item;
                    destination.item = currentItem;
                    origin.item = temp;
                    return;
                  } else {
                    Item temp = destination.item;
                    destination.item = null;
                    destination.weapon = currentWeapon;
                    origin.weapon = null;
                    origin.item = temp;
                    return;
                  }
                } else {
                  if (currentItem != null) {
                    Weapon temp = destination.weapon;
                    destination.weapon = null;
                    destination.item = currentItem;
                    origin.weapon = temp;
                    origin.item = null;
                    return;
                  } else {
                    Weapon temp = destination.weapon;
                    destination.weapon = currentWeapon;
                    origin.weapon = temp;
                    return;
                  }
                }
              } else {
                //Place item
                destination.isTaken = true;
                origin.isTaken = false;
                if (isItemSlot(origin)) {
                  destination.item = currentItem;
                  System.out.println(destination.item.name);
                  origin.item = null;
                  return;
                } else {
                  destination.weapon = currentWeapon;
                  origin.item = null;
                  return;
                }
              }
            }
          }
          //Return to original position
        }
        if (isItemSlot(origin)) origin.item = currentItem;
        else origin.weapon = currentWeapon;
        currentItem = null;
        currentWeapon =null;
      }
    }
  }

  void showStats(Player player) {
    fill(0);
    textSize(20);
    text("Health: " + player.health + "/" + player.maxHealth, 300, 230);
    text("Armor: " + player.armor, 300, 260);
    text("Speed: " + player.speed, 300, 290);
    text("Dodge Rate: " + player.dodgeRate, 300, 320);
    text("Sp.Attack: " + player.specialAttack, 300, 350);
    text("Attack Power: " + player.attackPower, 300, 380);
    text("Level: " + player.level, 550, 260);
    text("Exp: " + player.exp +"/"+player.expNeeded, 550, 290);
    text("Gold: " + player.gold, 550, 320);
    text("Defense: " + player.defense, 550, 350);

    text("Sp.Defense: " + player.specialDefense, 550, 380);

    if (player.weapon == null) {
      text("No Item Equipped:", 600, 230);
    } else {
      text("Item Equipped: " + player.weapon.name, 550, 230);
    }
  }
  boolean processTime(int x) {
    return delay+(x*100) < millis();
  }
}
