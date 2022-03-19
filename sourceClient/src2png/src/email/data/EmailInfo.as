// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.data.EmailInfo

package email.data
{
    import ddt.manager.LanguageMgr;
    import flash.utils.Dictionary;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;

    public class EmailInfo 
    {

        public var ID:int;
        public var UserID:int;
        public var MailType:int;
        public var Content:String = ddt.manager.LanguageMgr.GetTranslation("tank.data.EmailInfo.test");
        public var Title:String = ddt.manager.LanguageMgr.GetTranslation("tank.data.EmailInfo.email");
        public var Sender:String = ddt.manager.LanguageMgr.GetTranslation("tank.data.EmailInfo.random");
        public var SenderID:int;
        public var ReceiverID:int;
        public var SendTime:String;
        public var Annexs:Dictionary;
        public var Annex1:InventoryItemInfo;
        public var Annex2:InventoryItemInfo;
        public var Annex3:InventoryItemInfo;
        public var Annex4:InventoryItemInfo;
        public var Annex5:InventoryItemInfo;
        public var Annex1ID:int;
        public var Annex2ID:int;
        public var Annex3ID:int;
        public var Annex4ID:int;
        public var Annex5ID:int;
        public var Gold:Number = 500;
        public var Money:Number = 600;
        public var BindMoney:Number = 0;
        public var ValidDate:int = 30;
        public var Type:int = 0;
        public var IsRead:Boolean = false;


        public function getAnnexs():Array
        {
            var _local_1:Array = new Array();
            if (this.Annex1)
            {
                _local_1.push(this.Annex1);
            };
            if (this.Annex2)
            {
                _local_1.push(this.Annex2);
            };
            if (this.Annex3)
            {
                _local_1.push(this.Annex3);
            };
            if (this.Annex4)
            {
                _local_1.push(this.Annex4);
            };
            if (this.Annex5)
            {
                _local_1.push(this.Annex5);
            };
            if (this.Gold != 0)
            {
                _local_1.push("gold");
            };
            if (this.Money != 0)
            {
                _local_1.push("money");
            };
            if (this.BindMoney != 0)
            {
                _local_1.push("bindMoney");
            };
            return (_local_1);
        }

        public function get canReply():Boolean
        {
            if (PlayerManager.Instance.Self.ID == this.SenderID)
            {
                return (false);
            };
            switch (this.Type)
            {
                case 0:
                case 1:
                case 6:
                case 7:
                case 10:
                case 67:
                case 101:
                case EmailType.CONSORTION_EMAIL:
                    return (true);
                default:
                    return (false);
            };
        }

        public function getAnnexByIndex(_arg_1:int):*
        {
            var _local_2:*;
            var _local_3:Array = this.getAnnexs();
            if (_arg_1 > -1)
            {
                _local_2 = _local_3[_arg_1];
            };
            return (_local_2);
        }

        public function hasAnnexs():Boolean
        {
            if ((((((this.Annex1) || (this.Annex2)) || (this.Annex3)) || (this.Annex4)) || (this.Annex5)))
            {
                return (true);
            };
            return (false);
        }


    }
}//package email.data

