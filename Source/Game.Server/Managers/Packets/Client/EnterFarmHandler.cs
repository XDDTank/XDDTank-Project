using System;
using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using Game.Base.Packets;
using Game.Server.GameObjects;
//using Game.Server.Managers;
using Bussiness;
using SqlDataProvider.Data;
//using Game.Server.Rooms;
using Game.Logic;
//using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.FARM, "游戏创建")]
    public class EnterFarmHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            byte farm_cmd = packet.ReadByte();
            switch (farm_cmd)
            {
                case (int)FarmPackageType.ACCELERATE_FIELD:
                    {
                        int emptyValue = packet.ReadByte();
                        int emptyValue1 = packet.ReadInt();
                        int fieldId = packet.ReadInt();
                        int TemplateID = packet.ReadInt();//autoFertilizerID

                        Console.WriteLine("//ACCELERATE_FIELD ");
                        break;
                    }
                case (int)FarmPackageType.COMPOSE_FOOD:
                    {
                        int foodID = packet.ReadInt();
                        int type = packet.ReadInt();
                        Console.WriteLine("//COMPOSE_FOOD ");
                        break;
                    }
                case (int)FarmPackageType.ENTER_FARM:
                    {
                        int userId = packet.ReadInt();
                        if (userId == client.Player.PlayerCharacter.ID)
                        {
                            client.Player.Farm.CropHelperSwitchField(false);
                            client.Player.Farm.EnterFarm();
                            if (client.Player.PlayerCharacter.IsFistGetPet)
                            {
                                List<UsersPetinfo> lists = PetMgr.CreateFirstAdoptList(userId);
                                client.Player.PetBag.ClearAdoptPets();
                                foreach (UsersPetinfo pet in lists)
                                {
                                    client.Player.PetBag.AddAdoptPetTo(pet, pet.Place);
                                }
                                client.Player.RemoveFistGetPet();
                            }
                            if (client.Player.PlayerCharacter.LastRefreshPet.Date != DateTime.Now.Date)
                            {
                                List<UsersPetinfo> lists = PetMgr.CreateAdoptList(userId);
                                client.Player.PetBag.ClearAdoptPets();
                                foreach (UsersPetinfo pet in lists)
                                {
                                    client.Player.PetBag.AddAdoptPetTo(pet, pet.Place);
                                }
                                client.Player.RemoveLastRefreshPet();
                            }

                        }
                        else
                        {
                            client.Player.Farm.EnterFriendFarm(userId);
                        }
                        break;
                    }

                case (int)FarmPackageType.EXIT_FARM:
                    {
                        client.Player.Farm.ExitFarm();
                        Console.WriteLine("//EXIT_FARM ");
                        break;
                    }
                case (int)FarmPackageType.FRUSH_FIELD:
                    {
                        Console.WriteLine("//FRUSH_FIELD ");
                        break;
                    }

                case (int)FarmPackageType.GAIN_FIELD:
                    {
                        int userId = packet.ReadInt();
                        int fieldId = packet.ReadInt();//param1.fieldID
                        string msg = "Thu hoạch thất bại!";
                        if (userId == client.Player.PlayerCharacter.ID)
                        {
                            if (client.Player.Farm.GainField(fieldId))
                            {
                                msg = "Thu hoạch thành công!";
                            }
                        }
                        else
                        {
                            if (client.Player.Farm.GainFriendFields(userId, fieldId))
                            {
                                msg = "Thao tác thành công.";
                            }
                            else
                            {
                                msg = "Không thể chộm nửa.";
                            }
                        }
                        client.Player.Out.SendMessage(eMessageType.Normal, msg);
                        break;
                    }

                case (int)FarmPackageType.GROW_FIELD:
                    {
                        int emptyValue = packet.ReadByte();
                        int templateID = packet.ReadInt();
                        int fieldId = packet.ReadInt();
                        if (client.Player.Farm.GrowField(fieldId, templateID))
                        {
                            client.Player.FarmBag.RemoveTemplate(templateID, 1);
                            client.Player.OnSeedFoodPetEvent();
                        }
                        break;
                    }
                case (int)FarmPackageType.HELPER_PAY_FIELD:
                    {
                        Console.WriteLine("//HELPER_PAY_FIELD ");
                        break;
                    }
                case (int)FarmPackageType.HELPER_SWITCH_FIELD:
                    {
                        string msg = "Hiện tại chưa hổ trợ trợ thủ!";
                        bool isHelper = packet.ReadBoolean();//_loc_2.writeBoolean(param1[0]); 
                        int seedID = packet.ReadInt();//    _loc_2.writeInt(_seedID);isAutoId
                        int seedTime = packet.ReadInt();//    _loc_2.writeInt(_seedTime);AutoValidDate
                        int haveCount = packet.ReadInt();//    _loc_2.writeInt(_haveCount);GainFieldId
                        int getCount = packet.ReadInt();//    _loc_2.writeInt(_getCount);KillCropId
                        int moneyType = packet.ReadInt();//    _loc_2.writeInt(_moneyType);-2:DDTMoney/ -1:Money
                        int needMoney = packet.ReadInt();//    _loc_2.writeInt(_needMoney);
                        bool isOpen = false;
                        if (isHelper)
                        {

                            if (client.Player.PlayerCharacter.Money >= needMoney && moneyType == -1)
                            {
                                client.Player.RemoveMoney(needMoney);
                                isOpen = true;
                            }
                            else if (client.Player.PlayerCharacter.GiftToken >= needMoney && moneyType == -2)
                            {
                                client.Player.RemoveGiftToken(needMoney);
                                isOpen = true;
                            }
                            else
                            {
                                if (moneyType == -1)
                                    msg = "Xu không đủ!";
                                else
                                    msg = "Xu khóa không đủ!";
                            }

                        }
                        else
                        {
                            msg = "Hủy trợ thủ thành công!";
                            client.Player.Farm.CropHelperSwitchField(true);
                        }
                        if (isOpen)
                        {
                            msg = "Kích hoạt trợ thủ thành công!";
                        }
                        client.Player.Farm.HelperSwitchField(isHelper, seedID, seedTime, haveCount, getCount);
                        client.Out.SendMessage(eMessageType.Normal, msg);
                        break;
                    }
                case (int)FarmPackageType.KILLCROP_FIELD:
                    {
                        int fieldId = packet.ReadInt();
                        client.Player.Farm.killCropField(fieldId);
                        break;
                    }
                case (int)FarmPackageType.PAY_FIELD:// mở rộng
                    {
                        string msg = "Mở rộng thành công!";
                        List<int> fieldIds = new List<int>();
                        int fieldCount = packet.ReadInt();//_loc_3.writeInt(_fieldId.length);/
                        for (int i = 0; i < fieldCount; i++)
                        {
                            int fieldId = packet.ReadInt();
                            fieldIds.Add(fieldId);//_loc_3.writeInt(_loc_4);/
                        }
                        int payFieldTime = packet.ReadInt();//_loc_3.writeInt(payFieldTime);//week or month/
                        int payMoney = 0;
                        var farm = client.Player.Farm;
                        if (farm.payFieldTimeToMonth() == payFieldTime)
                        {
                            payMoney = fieldCount * farm.payFieldMoneyToMonth();
                        }
                        else
                        {
                            payMoney = fieldCount * farm.payFieldMoneyToWeek();
                        }
                        if (client.Player.PlayerCharacter.Money >= payMoney)
                        {
                            farm.PayField(fieldIds, payFieldTime);
                            client.Player.RemoveMoney(payMoney);
                        }
                        else
                        {
                            msg = "Xu không đủ!";
                        }
                        client.Out.SendMessage(eMessageType.Normal, msg);
                        break;
                    }


            }
            client.Player.Farm.SaveToDatabase();
            return 0;
        }
    }
}
