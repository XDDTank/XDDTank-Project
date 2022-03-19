// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.msg.FightMsgInfo

package SingleDungeon.expedition.msg
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ItemManager;

    public class FightMsgInfo 
    {

        private var _templateID:int;
        public var times:int;
        public var dungeonName:String;
        public var count:int;
        public var name:String;


        public function set templateID(_arg_1:int):void
        {
            var _local_2:ItemTemplateInfo;
            this._templateID = _arg_1;
            if ((((!(_arg_1 == 1)) && (!(_arg_1 == -1))) && (!(_arg_1 == -2))))
            {
                if (this._templateID == -3)
                {
                    this.name = LanguageMgr.GetTranslation("gold");
                }
                else
                {
                    if (this._templateID == -100)
                    {
                        this.name = LanguageMgr.GetTranslation("exp");
                    }
                    else
                    {
                        _local_2 = ItemManager.Instance.getTemplateById(this._templateID);
                        this.name = _local_2.Name;
                    };
                };
            };
        }

        public function get templateID():int
        {
            return (this._templateID);
        }


    }
}//package SingleDungeon.expedition.msg

