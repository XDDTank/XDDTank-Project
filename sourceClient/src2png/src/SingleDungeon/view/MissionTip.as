// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.MissionTip

package SingleDungeon.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import flash.display.Sprite;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.quest.QuestInfo;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class MissionTip extends BaseTip 
    {

        private var _container:Sprite;
        private var _bg:ScaleBitmapImage;


        override protected function init():void
        {
            this._container = new Sprite();
            this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
            super.init();
            this.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._container);
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            var _local_2:Vector.<QuestInfo> = (_arg_1 as Vector.<QuestInfo>);
            if (_local_2 == null)
            {
                return;
            };
            _tipData = _local_2;
            this.removeContent();
            this.addContent();
            this.drawBG();
        }

        private function addContent():void
        {
            var _local_2:FilterFrameText;
            var _local_3:Image;
            var _local_1:int;
            while (_local_1 < this.tipData.length)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("singledungeon.missionTip.description");
                _local_2.text = this.tipData[_local_1].Detail;
                _local_2.y = (20 + (_local_1 * 45));
                this._container.addChild(_local_2);
                if (_local_1 != (this.tipData.length - 1))
                {
                    _local_3 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
                    _local_3.y = ((_local_2.y + _local_2.height) + 10);
                    _local_3.x = 12;
                    this._container.addChild(_local_3);
                };
                _local_1++;
            };
        }

        private function removeContent():void
        {
            while (this._container.numChildren > 0)
            {
                this._container.removeChildAt(0);
            };
        }

        private function drawBG():void
        {
            this._bg.width = (this._container.width + 10);
            this._bg.height = (this._container.height + 40);
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
            };
            this._container = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package SingleDungeon.view

