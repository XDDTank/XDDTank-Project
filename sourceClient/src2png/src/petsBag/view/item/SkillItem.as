// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.SkillItem

package petsBag.view.item
{
    import com.pickgliss.ui.core.Component;
    import pet.date.PetSkillInfo;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import ddt.view.tips.ToolPropInfo;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.display.BitmapLoaderProxy;
    import ddt.manager.PathManager;
    import flash.geom.Rectangle;
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    public class SkillItem extends Component 
    {

        public static const ZOOMVALUE:Number = 0.5;

        protected var _info:PetSkillInfo;
        protected var _skillIcon:DisplayObject;
        private var _iconPos:Point;
        protected var _tipInfo:ToolPropInfo;
        public var DoubleClickEnabled:Boolean = false;
        private var _skillID:int = -1;

        public function SkillItem()
        {
            this._iconPos = new Point();
            this.initView();
            this.initEvent();
        }

        override public function get tipStyle():String
        {
            return ("ddt.view.tips.PetSkillCellTip");
        }

        override public function get tipData():Object
        {
            return (this._info);
        }

        public function get skillID():int
        {
            return (this._skillID);
        }

        public function get iconPos():Point
        {
            return (this._iconPos);
        }

        public function set iconPos(_arg_1:Point):void
        {
            this._iconPos = _arg_1;
            this.updateSize();
        }

        protected function initView():void
        {
            tipDirctions = "5,2,7,1,6,4";
            tipGapV = (tipGapH = 20);
        }

        private function initEvent():void
        {
        }

        private function removeEvent():void
        {
        }

        public function updateSize():void
        {
            if (this._skillIcon)
            {
                this._skillIcon.x = ((width - 38) / 2);
                this._skillIcon.y = ((height - 38) / 2);
            };
        }

        public function get info():PetSkillInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:PetSkillInfo):void
        {
            if ((((this._info) && (_arg_1)) && (this._info.ID == _arg_1.ID)))
            {
                return;
            };
            this._info = _arg_1;
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeObject(this._skillIcon);
            this._skillIcon = null;
            _tipData = null;
            if (((this._info) && (this._info.ID > 0)))
            {
                this._skillIcon = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(this._info.Pic), new Rectangle(0, 0, 44, 44));
                addChild(this._skillIcon);
                this.updateSize();
                ShowTipManager.Instance.addTip(this);
            };
        }

        protected function creatDragImg():DisplayObject
        {
            var _local_1:Bitmap = new Bitmap(new BitmapData((this._skillIcon.width / this._skillIcon.scaleX), (this._skillIcon.height / this._skillIcon.scaleY), true, 0xFFFFFFFF));
            _local_1.bitmapData.draw(this._skillIcon);
            _local_1.scaleX = 0.75;
            _local_1.scaleY = 0.75;
            return (_local_1);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._skillIcon);
            this._skillIcon = null;
            this._info = null;
            ObjectUtils.disposeAllChildren(this);
            super.dispose();
        }


    }
}//package petsBag.view.item

