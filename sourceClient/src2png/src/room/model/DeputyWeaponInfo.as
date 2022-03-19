// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.model.DeputyWeaponInfo

package room.model
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.LanguageMgr;
    import bagAndInfo.cell.BagCell;
    import flash.display.DisplayObject;

    public class DeputyWeaponInfo 
    {

        private var _info:ItemTemplateInfo;
        public var energy:Number = 110;
        public var ballId:int;
        public var coolDown:int = 2;
        public var weaponType:int = 0;
        public var name:String = LanguageMgr.GetTranslation("tank.auctionHouse.view.offhand");

        public function DeputyWeaponInfo(_arg_1:ItemTemplateInfo)
        {
            this._info = _arg_1;
            if (this._info)
            {
                this.energy = Number(this._info.Property4);
                this.ballId = int(this._info.Property1);
                this.coolDown = int(this._info.Property6);
                this.weaponType = int(this._info.Property3);
                this.name = this._info.Name;
            };
        }

        public function dispose():void
        {
            this._info = null;
        }

        public function getDeputyWeaponIcon(_arg_1:int=0):DisplayObject
        {
            var _local_2:BagCell = new BagCell(0, this._info);
            if (_arg_1 == 0)
            {
                return (_local_2.getContent());
            };
            if (_arg_1 == 1)
            {
                return (_local_2.getSmallContent());
            };
            return (null);
        }

        public function get isShield():Boolean
        {
            return ((!(this._info == null)) && ((this._info.TemplateID == 17003) || (this._info.TemplateID == 17004)));
        }

        public function get Pic():String
        {
            return (this._info.Pic);
        }

        public function get TemplateID():int
        {
            return (this._info.TemplateID);
        }

        public function get Template():ItemTemplateInfo
        {
            return (this._info);
        }


    }
}//package room.model

