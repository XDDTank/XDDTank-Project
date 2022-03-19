// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.others.PetOtherRightInfoView

package petsBag.view.others
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import petsBag.view.PetInfoView;
    import petsBag.view.item.PetBigItem;
    import pet.date.PetInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class PetOtherRightInfoView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _infoView:PetInfoView;
        private var _pet:PetBigItem;
        private var _info:PetInfo;

        public function PetOtherRightInfoView()
        {
            this.init();
            this.initEvent();
        }

        protected function init():void
        {
            this._bg = ComponentFactory.Instance.creat("petsBag.view.other.petInfoView.bg");
            addChild(this._bg);
            this._infoView = ComponentFactory.Instance.creat("petsBag.view.OtherpetInfoView");
            this._infoView.setVisible(false);
            addChild(this._infoView);
        }

        private function initEvent():void
        {
        }

        private function removeEvent():void
        {
        }

        public function get info():PetInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:PetInfo):void
        {
            this._info = _arg_1;
            this.update();
        }

        public function update():void
        {
            if (this._info)
            {
                this._infoView.info = this._info;
            }
            else
            {
                this._infoView.info = null;
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            this._infoView.dispose();
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package petsBag.view.others

