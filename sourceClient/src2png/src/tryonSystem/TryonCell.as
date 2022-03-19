// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tryonSystem.TryonCell

package tryonSystem
{
    import shop.view.ShopItemCell;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.DisplayObject;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.utils.PositionUtils;
    import flash.display.Sprite;
    import ddt.manager.SoundManager;
    import ddt.manager.TaskManager;
    import com.pickgliss.utils.ObjectUtils;

    public class TryonCell extends ShopItemCell 
    {

        private var _background:ScaleBitmapImage;

        public function TryonCell(_arg_1:DisplayObject, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:Boolean=true)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override protected function init():void
        {
            super.init();
            this._background = ComponentFactory.Instance.creatComponentByStylename("asset.core.tryon.cellBG");
            addChildAt(this._background, 0);
            overBg = ComponentFactory.Instance.creatComponentByStylename("asset.core.tryon.cellLight");
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        override protected function updateSize(_arg_1:Sprite):void
        {
            super.updateSize(_arg_1);
            PositionUtils.setPos(_arg_1, "ddt.tryoncell.pos");
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (((!(overBg.visible)) && (_arg_1)))
            {
                SoundManager.instance.play("008");
            };
            overBg.visible = _arg_1;
            TaskManager.instance.Model.itemAwardSelected = this.info.TemplateID;
        }

        public function get selected():Boolean
        {
            return (overBg.visible);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._background);
            this._background = null;
            super.dispose();
        }


    }
}//package tryonSystem

