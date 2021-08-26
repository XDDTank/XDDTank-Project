using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.GameUtils;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.NEWCHICKENBOX_SYS, "Rương gà")]
    public class NewChickenBoxHandler : IPacketHandler
    {
        //tạo mảng lưu các item
        int[] ItemArray = new int[18];
        //hàm thêm item vào mảng
        public void AddItemToArray()
        {
            int i, itemid = 7024;
            for (i = 0; i < 18; i++)
            {
                ItemArray[i] = itemid;
                itemid++;
            }
        }
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.NEWCHICKENBOX_SYS, client.Player.PlayerCharacter.ID);
            int cmd = packet.ReadInt();//đọc số client trả về;
            switch (cmd)
            {
                case (int)NewChickenBoxPackageType.CLICKSTARTBNT://ấn bắt đầu
                    pkg.WriteInt((int)NewChickenBoxPackageType.CANCLICKCARD);
                    pkg.WriteBoolean(true);
                    client.Out.SendTCP(pkg);
                    client.Player.OpenTime = 5;//đặt số lượt mở thẻ mặc định
                    client.Player.DefaultOpenMoney = 5;
                    client.Player.DefaultEyeMoney = 5;
                    Console.WriteLine("NEWCHICKENBOX_SYS : CLICKSTARTBTN");//báo log trên server
                    break;
                case (int)NewChickenBoxPackageType.ENTERCHICKENVIEW://click icon
                    AddItemToArray();
                    pkg.WriteInt((int)NewChickenBoxPackageType.GETITEMLIST);//gửi lên server packet lấy danh sách item
                    pkg.WriteDateTime(DateTime.Now);//this._model.lastFlushTime = _loc_2.readDate();//lần tạo mới cuối cùng
                    pkg.WriteInt(1);//this._model.freeFlushTime = _loc_2.readInt();//lần tạo mới miễn phí
                    pkg.WriteBoolean(true);//this._model.isShowAll = _loc_2.readBoolean();//có hiển thị hết item hay ko
                    pkg.WriteInt(18);//this._model.boxCount = _loc_2.readInt();//số item
                    int _loc_3 = 0;//var _loc_3:int = 0;
                    while (_loc_3 < 18)
                    {
                        pkg.WriteInt(ItemArray[_loc_3]);//_loc_4.TemplateID = _loc_2.readInt(); itemid của item
                        pkg.WriteInt(12);//_loc_4.StrengthenLevel = _loc_2.readInt();//cấp độ của item
                        pkg.WriteInt(1);//_loc_4.Count = _loc_2.readInt();//số lượng
                        pkg.WriteInt(1);//_loc_4.ValidDate = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_4.AttackCompose = _loc_2.readInt();//hợpthành
                        pkg.WriteInt(10);//_loc_4.DefendCompose = _loc_2.readInt();//hợpthành
                        pkg.WriteInt(10);//_loc_4.AgilityCompose = _loc_2.readInt();//hợpthành
                        pkg.WriteInt(10);//_loc_4.LuckCompose = _loc_2.readInt();//hợpthành
                        pkg.WriteInt(_loc_3);//_loc_4.Position = _loc_2.readInt();//vị trí của item trong rương gà
                        pkg.WriteBoolean(false);//_loc_4.IsSelected = _loc_2.readBoolean();//item đã dc chọn hay chưa
                        pkg.WriteBoolean(false);//_loc_4.IsSeeded = _loc_2.readBoolean();//có nhìn xuyên thấu item ko
                        pkg.WriteBoolean(true);//_loc_4.IsBinds = _loc_2.readBoolean();//item có khóa hay ko
                        _loc_3++;//quên thêm cái này
                    }
                    //gửi về client
                    client.Out.SendTCP(pkg);
                    Console.WriteLine("NEWCHICKENBOX_SYS : ENTERCHICKENVIEW");//báo log trên server
                    break;
                case (int)NewChickenBoxPackageType.FLUSHCHICKENVIEW://tạo mới
                    client.Out.SendMessage(eMessageType.Normal, "Chức năng này chưa hỗ trợ");//lười dev quớ
                    Console.WriteLine("NEWCHICKENBOX_SYS : FLUSHCHICKENVIEW");//báo log trên server
                    break;
                case (int)NewChickenBoxPackageType.TAKEOVERCARD://mở thẻ bài
                    //kiểm tra 
                    bool flag = true;
                    if (client.Player.OpenTime < 0)
                    {
                        client.Out.SendMessage(eMessageType.Normal,"Đã hết số lần lật thẻ");
                        flag = false;
                    }
                    if (client.Player.PlayerCharacter.Money < client.Player.DefaultOpenMoney)
                    {
                        client.Out.SendMessage(eMessageType.Normal, "Xu không đủ");
                        flag = false;
                    }
                    int vitri = packet.ReadInt();//vị trí của thẻ dc click
                    if (flag)
                    {
                        pkg.WriteInt((int)NewChickenBoxPackageType.TACKOVERCARD);
                        pkg.WriteInt(ItemArray[vitri]);//_loc_3.TemplateID = _loc_2.readInt();
                        pkg.WriteInt(12);//_loc_3.StrengthenLevel = _loc_2.readInt();
                        pkg.WriteInt(1);//_loc_3.Count = _loc_2.readInt();
                        pkg.WriteInt(1);//_loc_3.ValidDate = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_3.AttackCompose = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_3.DefendCompose = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_3.AgilityCompose = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_3.LuckCompose = _loc_2.readInt();
                        pkg.WriteInt(vitri);//_loc_3.Position = _loc_2.readInt();
                        pkg.WriteBoolean(true);//_loc_3.IsSelected = _loc_2.readBoolean();
                        pkg.WriteBoolean(false);//_loc_3.IsSeeded = _loc_2.readBoolean();
                        pkg.WriteBoolean(true);//_loc_3.IsBinds = _loc_2.readBoolean();
                        client.Out.SendTCP(pkg);
                        client.Player.PlayerCharacter.Money -= client.Player.DefaultOpenMoney;//trừ tiền
                        client.Player.DefaultOpenMoney += 5;
                        client.Player.OpenTime--;
                        //gửi item cho user
                        ItemTemplateInfo prop = ItemMgr.FindItemTemplate(ItemArray[vitri]);
                        ItemInfo item = new ItemInfo(prop);
                        client.Player.AddTemplate(item, eBageType.MainBag, 1);
                        client.Out.SendMessage(eMessageType.Normal,"Chúc mừng bạn lật rương gà nhận được vật phẩm " + prop.Name);
                    }
                    Console.WriteLine("NEWCHICKENBOX_SYS : TAKEOVERCARD "+vitri);//báo log trên server
                    break;
                case (int)NewChickenBoxPackageType.USEEAGLEEYE://xuyên thấu
                    bool flag1 = true;
                    int position = packet.ReadInt();//vị trí
                    if (client.Player.PlayerCharacter.Money < client.Player.DefaultEyeMoney)
                    {
                        client.Out.SendMessage(eMessageType.Normal, "Xu không đủ");
                        flag1 = false;
                    }
                    if (flag1)
                    {
                        pkg.WriteInt((int)NewChickenBoxPackageType.EAGLEEYE);
                        pkg.WriteInt(ItemArray[position]);//_loc_3.TemplateID = _loc_2.readInt();
                        pkg.WriteInt(12);//_loc_3.StrengthenLevel = _loc_2.readInt();
                        pkg.WriteInt(1);//_loc_3.Count = _loc_2.readInt();
                        pkg.WriteInt(1);//_loc_3.ValidDate = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_3.AttackCompose = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_3.DefendCompose = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_3.AgilityCompose = _loc_2.readInt();
                        pkg.WriteInt(10);//_loc_3.LuckCompose = _loc_2.readInt();
                        pkg.WriteInt(position);//_loc_3.Position = _loc_2.readInt();
                        pkg.WriteBoolean(false);//_loc_3.IsSelected = _loc_2.readBoolean();
                        pkg.WriteBoolean(true);//_loc_3.IsSeeded = _loc_2.readBoolean();
                        pkg.WriteBoolean(true);//_loc_3.IsBinds = _loc_2.readBoolean();
                        client.Out.SendTCP(pkg);
                        client.Player.PlayerCharacter.Money -= client.Player.DefaultEyeMoney;
                        client.Player.DefaultEyeMoney += 10;
                    }
                    Console.WriteLine("NEWCHICKENBOX_SYS : USEEAGLEEYE " + position);//báo log trên server
                    break;
                default:
                    break;
            }
            return 0;
        }
    }
}
