// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.MemberDiamondGiftCell

package platformapi.tencent.view
{
    import bagAndInfo.cell.BagCell;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.UICreatShortcut;
    import flash.geom.Point;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ItemManager;
    import ddt.data.DaylyGiveInfo;

    public class MemberDiamondGiftCell extends BagCell 
    {

        private var _BG:Bitmap;
        private var _nameText:FilterFrameText;
        private var _light:Bitmap;

        public function MemberDiamondGiftCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:DisplayObject=null)
        {
            this._BG = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.RightCellBG", this);
            this._nameText = UICreatShortcut.creatAndAdd("memberDiamondGift.view.MemberDiamondGiftRightView.cellText", this);
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _bg.visible = false;
            _picPos = new Point(20, 20);
            this._light = UICreatShortcut.creatAndAdd("asset.memberDiamondNewHandGift.light", this);
            this._light.visible = false;
        }

        public function showLight():void
        {
            if (this._light)
            {
                this._light.visible = true;
            };
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        public function set nameTextStyle(_arg_1:String):void
        {
            ObjectUtils.disposeObject(this._nameText);
            this._nameText = null;
            this._nameText = UICreatShortcut.creatAndAdd(_arg_1, this);
        }

        public function setInfo(_arg_1:DaylyGiveInfo):void
        {
            var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_arg_1.TemplateID);
            this._nameText.text = ((_local_2.Name + "x") + _arg_1.Count.toString());
            info = _local_2;
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._BG);
            this._BG = null;
            ObjectUtils.disposeObject(this._nameText);
            this._nameText = null;
            ObjectUtils.disposeObject(this._light);
            this._light = null;
            super.dispose();
        }


    }
}//package platformapi.tencent.view

