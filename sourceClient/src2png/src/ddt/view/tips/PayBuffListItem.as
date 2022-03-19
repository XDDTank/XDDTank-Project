// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.PayBuffListItem

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Dictionary;
    import ddt.data.BuffInfo;
    import ddt.data.FightBuffInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class PayBuffListItem extends Sprite implements Disposeable 
    {

        private var _icon:DisplayObject;
        private var _labelField:FilterFrameText;
        private var _timeField:FilterFrameText;
        private var _w:int;
        private var _h:int;
        private var _countField:FilterFrameText;
        private var levelDic:Dictionary = new Dictionary();

        public function PayBuffListItem(_arg_1:*)
        {
            this.initLevelDic();
            var _local_2:String = "";
            if ((_arg_1 is BuffInfo))
            {
                _local_2 = ("asset.core.payBuffAsset" + _arg_1.Type);
            }
            else
            {
                if ((_arg_1 is FightBuffInfo))
                {
                    _local_2 = ("asset.game.buff" + _arg_1.displayid);
                };
            };
            this._icon = addChild(ComponentFactory.Instance.creatBitmap(_local_2));
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject("asset.core.PayBuffIconSize");
            this._icon.width = _local_3.x;
            this._icon.height = _local_3.y;
            this._labelField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipLabel");
            this._labelField.text = _arg_1.buffName;
            addChild(this._labelField);
            if ((_arg_1 is BuffInfo))
            {
                this._countField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipCount");
                if (((_arg_1.maxCount > 0) && (_arg_1.isSelf)))
                {
                    this._countField.text = ((_arg_1.ValidCount + "/") + _arg_1.maxCount);
                };
                addChild(this._countField);
                this._timeField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipTime");
                this._timeField.text = LanguageMgr.GetTranslation("tank.view.buff.VipLevelFree", this.levelDic[_arg_1.Type]);
                addChild(this._timeField);
                this._w = (this._timeField.x + this._timeField.width);
            }
            else
            {
                this._timeField = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipTime");
                this._timeField.text = FightBuffInfo(_arg_1).description;
                addChild(this._timeField);
                this._timeField.x = ((this._labelField.x + this._labelField.textWidth) + 15);
                this._w = (this._timeField.x + this._timeField.width);
            };
            this._h = this._icon.height;
        }

        private function initLevelDic():void
        {
            this.levelDic[BuffInfo.Agility] = "7";
            this.levelDic[BuffInfo.Save_Life] = "4";
            this.levelDic[BuffInfo.ReHealth] = "6";
            this.levelDic[BuffInfo.Train_Good] = "8";
            this.levelDic[BuffInfo.Level_Try] = "3";
            this.levelDic[BuffInfo.Card_Get] = "5";
            this.levelDic[BuffInfo.Caddy_Good] = "9";
        }

        override public function get width():Number
        {
            return (this._w);
        }

        override public function get height():Number
        {
            return (this._h);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            ObjectUtils.disposeObject(this._labelField);
            this._labelField = null;
            ObjectUtils.disposeObject(this._timeField);
            this._timeField = null;
            ObjectUtils.disposeObject(this._countField);
            this._countField = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

