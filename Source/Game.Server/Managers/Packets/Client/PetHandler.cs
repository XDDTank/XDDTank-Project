using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;
using Bussiness.Managers;
using Game.Server.Managers;
using Game.Logic;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.PET, "添加好友")]
    public class PetHandler : IPacketHandler
    {
        //0友好，1黑名单
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            var pet_cmd = packet.ReadByte();
            
            string msg = "Seus Cupons não são suficiente deseja recarregar? ";
            int place = -1;
            int itemPlace = -1;
            int BagType = 1;
            UsersPetinfo[] pets;
            switch (pet_cmd)
            {
                case (int)FarmPackageType.BUY_PET_EXP_ITEM:
                    {
                        Console.WriteLine("//BUY_PET_EXP_ITEM ");
                        bool buyPetExpItem = packet.ReadBoolean();
                        break;
                    }
                case (byte)ePetType.UPDATE_PET:
                    {
                        UpdatePetHandle(client, packet.ReadInt());
                    }
                    break;
                case (byte)ePetType.ADD_PET:
                    {
                        //Console.WriteLine("//ADD_PET ");
                        itemPlace = packet.ReadInt();
                        BagType = packet.ReadInt();
                        int userID = client.Player.PlayerCharacter.ID;
                        int index = client.Player.PetBag.FindFirstEmptySlot();
                        if (index == -1)
                        {
                            client.Player.SendMessage("O número de pets foi atigindos liberte alguns pets!");
                        }
                        else
                        {
                            ItemInfo egg = client.Player.GetItemAt((eBageType)BagType, itemPlace);
                            PetTemplateInfo TempInfo = PetMgr.FindPetTemplate(egg.Template.Property5);
                            UsersPetinfo info = PetMgr.CreatePet(TempInfo, userID, index);
                            using (PlayerBussiness pb = new PlayerBussiness())
                            {
                                info.IsExit = false;
                                pb.AddUserAdoptPet(info, true);
                            }
                            info.IsExit = true;
                            client.Player.PetBag.AddPetTo(info, index);
                            client.Player.MainBag.RemoveCountFromStack(egg, 1);
                            client.Player.SendMessage("Você recebeu sua experiencia e seu pet volto ao nível 1 " + TempInfo.Name);

                        }
                    }
                    break;
                case (byte)Game.Logic.eTankCmdType.REVER_PET:
                    {
                        place = packet.ReadInt();
                        RevertPetHandle(client, place, msg);
                    }
                    break;
                case (byte)ePetType.MOVE_PETBAG:
                    {
                        Console.WriteLine("//MOVE_PETBAG ");
                        place = packet.ReadInt();
                    }
                    break;
                case (byte)ePetType.FEED_PET:
                    {
                        itemPlace = packet.ReadInt();
                        BagType = packet.ReadInt();
                        place = packet.ReadInt();
                        bool result = false;
                        ItemInfo Item = client.Player.GetItemAt((eBageType)BagType, itemPlace);
                        int MaxHunger = Convert.ToInt32(PetMgr.FindConfig("MaxHunger").Value);
                        int MaxLevel = Convert.ToInt32(PetMgr.FindConfig("MaxLevel").Value);
                        UsersPetinfo r_pet = client.Player.PetBag.GetPetAt(place);
                        int count = Item.Count;
                        int expItem = Item.Template.Property2;
                        int hungerItem = Item.Template.Property3;
                        int hunger = count * hungerItem;
                        int totalhunger = hunger + r_pet.Hunger;
                        int exp = count * expItem;
                        msg = "";
                        if (Item.TemplateID == 334100)
                        {
                            exp = Item.DefendCompose;
                        }
                        if (r_pet.Level > 11 && Item.TemplateID == 334100)
                        {
                            msg = ("Grande porção de experiencia só no nível 10 menos. " + Item.Template.Name);
                        }
                        else if (r_pet.Level < MaxLevel)
                        {
                            exp += r_pet.GP;

                            int currentlv = r_pet.Level;
                            int nextlv = PetMgr.GetLevel(exp);
                            int maxGP = PetMgr.GetGP(nextlv + 1);
                            int GpMaxLv = PetMgr.GetGP(MaxLevel);
                            int finalExp = exp;

                            if (exp > GpMaxLv)
                            {
                                exp -= GpMaxLv;
                                if (exp >= expItem && expItem != 0)
                                { count = exp / expItem; }
                            }
                            r_pet.GP = finalExp >= GpMaxLv ? GpMaxLv : finalExp;
                            r_pet.Level = nextlv;
                            r_pet.MaxGP = maxGP == 0 ? GpMaxLv : maxGP;
                            r_pet.Hunger = totalhunger > MaxHunger ? MaxHunger : totalhunger;
                            result = client.Player.PetBag.UpGracePet(r_pet, place, true, currentlv, nextlv, ref msg);
                            if (Item.TemplateID == 334100)
                            {                                
                                client.Player.StoreBag.RemoveItem(Item);
                            }
                            else
                            {                                
                                client.Player.StoreBag.RemoveCountFromStack(Item, count);
                                client.Player.OnUsingItem(Item.TemplateID);
                            }
                        }
                        else
                        {
                            int currenthunger = r_pet.Hunger;
                            int getHungger = MaxHunger - currenthunger;
                            if (totalhunger >= MaxHunger)
                            {
                                if (totalhunger >= hungerItem)
                                { count = totalhunger / hungerItem; }
                            }
                            totalhunger = currenthunger + getHungger;
                            r_pet.Hunger = totalhunger;
                            if (currenthunger < MaxHunger)
                            {                                
                                client.Player.StoreBag.RemoveCountFromStack(Item, count);
                                result = client.Player.PetBag.UpGracePet(r_pet, place, false, 0, 0, ref msg);
                                msg = ("Pura diversão exposições mais " + getHungger);
                            }
                            else
                            {
                                msg = ("Seu pet alcançou o nível máximo");
                            }

                        }                        
                        if (result)
                        {
                            pets = client.Player.PetBag.GetPets();
                            client.Player.Out.SendUpdatePetInfo(client.Player.PlayerCharacter, pets);
                        }
                        if (!string.IsNullOrEmpty(msg))
                        {
                            client.Player.SendMessage(msg);
                        }
                    }
                    break;
                case (byte)ePetType.REFRESH_PET:
                    {
                        bool refreshBtn = packet.ReadBoolean();
                        RefreshPetHandle(client, refreshBtn, msg);
                    }
                    break;
                case (byte)ePetType.ADOPT_PET:
                    {
                        place = packet.ReadInt();
                        //int MaxPetCount = Convert.ToInt32(PetMgr.FindConfig("MaxPetCount").Value);
                        int index = client.Player.PetBag.FindFirstEmptySlot();
                        if (index == -1)
                        {
                            client.Player.Out.SendRefreshPet(client.Player, client.Player.PetBag.GetAdoptPet(), null, false);
                            client.Player.SendMessage("O número de pet limite é atingido!");
                            
                        }
                        else
                        {
                            UsersPetinfo petAt = client.Player.PetBag.GetAdoptPetAt(place);
                            if (client.Player.PetBag.AddPetTo(petAt, index))
                            {
                                client.Player.PetBag.RemoveAdoptPet(petAt);
                                client.Player.OnAdoptPetEvent();
                            }
                                                        
                        }
                    }
                    break;
                case (byte)ePetType.EQUIP_PET_SKILL:
                    {
                        place = packet.ReadInt();
                        int killId = packet.ReadInt();
                        int killindex = packet.ReadInt();
                        if (client.Player.PetBag.EquipSkillPet(place, killId, killindex))
                        {
                            pets = client.Player.PetBag.GetPets();
                            client.Player.Out.SendUpdatePetInfo(client.Player.PlayerCharacter, pets);
                        }
                        else
                        {
                            client.Player.SendMessage("Skill já equipada!");
                        }
                    }
                    break;
                case (byte)ePetType.RELEASE_PET:
                    {
                        place = packet.ReadInt();
                        UsersPetinfo pet = client.Player.PetBag.GetPetAt(place);
                        if (client.Player.PetBag.RemovePet(pet))
                        {
                            using (PlayerBussiness pb = new PlayerBussiness())
                            {
                                pb.UpdateUserAdoptPet(pet.ID);
                            }
                        }
                        client.Player.SendMessage("Você libertou seu animal de estimação com sucesso!");
                    }
                    break;
                case (byte)ePetType.RENAME_PET:
                    {
                        place = packet.ReadInt();
                        string name = packet.ReadString();
                        int changeNameCost = Convert.ToInt32(PetMgr.FindConfig("ChangeNameCost").Value);
                        if (client.Player.PlayerCharacter.Money >= changeNameCost)
                        {
                            if (client.Player.PetBag.RenamePet(place, name))
                            {
                                pets = client.Player.PetBag.GetPets();
                                client.Out.SendUpdatePetInfo(client.Player.PlayerCharacter, pets);
                                msg = "Você renomeou seu pet com sucesso!";
                            }
                            client.Player.RemoveMoney(changeNameCost);
                        }
                        
                        client.Player.SendMessage(msg);
                    }
                    break;
                case (byte)ePetType.PAY_SKILL:
                    {
                        Console.WriteLine("//PAY_SKILL ");
                        place = packet.ReadInt();
                    }
                    break;
                case (byte)ePetType.FIGHT_PET:
                    {
                        place = packet.ReadInt();
                        bool isEquip = packet.ReadBoolean();
                        if (client.Player.PetBag.SetIsEquip(place, isEquip))
                        {
                            pets = client.Player.PetBag.GetPets();
                            client.Player.MainBag.UpdatePlayerProperties();
                            client.Player.Out.SendUpdatePetInfo(client.Player.PlayerCharacter, pets);
                        }
                        
                    }
                    break;
            }
            client.Player.PetBag.SaveToDatabase();
            return 0;
        }
        public void RevertPetHandle(GameClient client, int place, string msg)
        {
            int recycleCost = Convert.ToInt32(PetMgr.FindConfig("RecycleCost").Value);
            bool result = false;
            if (client.Player.PlayerCharacter.Money >= recycleCost)
            {
                UsersPetinfo r_pet = client.Player.PetBag.GetPetAt(place);
                UsersPetinfo o_pet = new UsersPetinfo();
                ItemTemplateInfo Item = ItemMgr.FindItemTemplate(334100);
                ItemInfo cloneItem = ItemInfo.CreateFromTemplate(Item, 1, 0);
                cloneItem.IsBinds = true;
                cloneItem.DefendCompose = r_pet.GP;
                cloneItem.AgilityCompose = r_pet.MaxGP;
                if (!client.Player.PropBag.AddTemplate(cloneItem, 1))
                {
                    client.Player.SendItemToMail(cloneItem, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), eMailType.ItemOverdue);
                    client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
                }
                //PropBag.UpdateChangedPlaces();
                int petId = r_pet.ID;
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    o_pet = db.GetAdoptPetSingle(petId);                    
                }
                r_pet.Blood = o_pet.Blood;
                r_pet.Attack = o_pet.Attack;
                r_pet.Defence = o_pet.Defence;
                r_pet.Agility = o_pet.Agility;
                r_pet.Luck = o_pet.Luck;
                int userID = client.Player.PlayerCharacter.ID;
                int templateID = o_pet.TemplateID;
                r_pet.TemplateID = templateID;
                r_pet.Skill = o_pet.Skill;
                r_pet.SkillEquip = o_pet.SkillEquip;
                r_pet.GP = 0;
                r_pet.Level = 1;
                r_pet.MaxGP = 55;
                result = client.Player.PetBag.UpGracePet(r_pet, place, false, 0, 0, ref msg);
                client.Player.SendMessage("Sucesso ao recuperar a experiencia do pet");
                client.Player.RemoveMoney(recycleCost);
                if (result)
                {
                    client.Player.Out.SendUpdatePetInfo(client.Player.PlayerCharacter, client.Player.PetBag.GetPets());
                }
            }
            else
            {
                client.Player.SendMessage(msg);
            }             
        }

        public void RefreshPetHandle(GameClient client, bool refreshBtn, string msg)
        {
            int refereshCost = Convert.ToInt32(PetMgr.FindConfig("AdoptRefereshCost").Value);
            int refereshId = Convert.ToInt32(PetMgr.FindConfig("FreeRefereshID").Value);
            
            ItemInfo FreeRefereshItem = client.Player.PropBag.GetItemByTemplateID(0, refereshId);
            
                if (refreshBtn)
                {
                    if (FreeRefereshItem != null)
                    {
                        client.Player.PropBag.RemoveTemplate(refereshId, 1);
                    }
                    else if (client.Player.PlayerCharacter.Money >= refereshCost)
                    {
                        client.Player.RemoveMoney(refereshCost);
                        client.Player.AddPetScore(refereshCost / 10);
                    }
                    else
                    {
                        client.Player.SendMessage(msg);
                    }
                    List<UsersPetinfo> lists = PetMgr.CreateAdoptList(client.Player.PlayerCharacter.ID);
                    client.Player.PetBag.ClearAdoptPets();
                    foreach (UsersPetinfo pet in lists)
                    {
                        client.Player.PetBag.AddAdoptPetTo(pet, pet.Place);
                    }
                    
                }
            
            client.Player.Out.SendRefreshPet(client.Player, client.Player.PetBag.GetAdoptPet(), null, refreshBtn);
        }

        public void UpdatePetHandle(GameClient client, int ID)
        {            
            GamePlayer player = Managers.WorldMgr.GetPlayerById(ID);
            PlayerInfo info;
            UsersPetinfo[] pets;
            if (player != null)
            {
                info = player.PlayerCharacter;
                pets = player.PetBag.GetPets().ToArray();                
            }
            else
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    info = pb.GetUserSingleByUserID(ID);
                    pets = pb.GetUserPetSingles(ID);
                    
                }
            }

            if (pets != null)
                client.Out.SendUpdatePetInfo(info, pets);
           
        }
    }
}
