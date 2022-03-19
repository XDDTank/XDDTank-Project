// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.BuildingLevelItem

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.ui.ComponentFactory;
    import consortion.ConsortionModel;
    import consortion.ConsortionModelControl;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class BuildingLevelItem extends Sprite implements Disposeable, ITipedDisplay 
    {

        private var _type:int = 0;
        private var _tipData:Object;
        private var _background:MutipleImage;
        private var _level:FilterFrameText;

        public function BuildingLevelItem(_arg_1:int)
        {
            this._type = _arg_1;
            this.initView();
        }

        private function initView():void
        {
            ShowTipManager.Instance.addTip(this);
            switch (this._type)
            {
                case ConsortionModel.SHOP:
                    this._background = ComponentFactory.Instance.creatComponentByStylename("consortion.shop");
                    break;
                case ConsortionModel.SKILL:
                    this._background = ComponentFactory.Instance.creatComponentByStylename("consortion.skill");
                    break;
            };
            this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.buildLevel");
            addChild(this._background);
            addChild(this._level);
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = ConsortionModelControl.Instance.model.getLevelString(this._type, (_arg_1 as int));
            this._level.text = ("Lv." + _arg_1);
        }

        public function get tipDirctions():String
        {
            return ("3");
        }

        public function set tipDirctions(_arg_1:String):void
        {
        }

        public function get tipGapH():int
        {
            return (0);
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipGapV():int
        {
            return (0);
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function get tipStyle():String
        {
            return ("consortion.ConsortiaLevelTip");
        }

        public function set tipStyle(_arg_1:String):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeAllChildren(this);
            this._background = null;
            this._level = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

