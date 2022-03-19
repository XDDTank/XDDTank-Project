// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.VipPrivilegeTxt

package vip.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.utils.ObjectUtils;

    public class VipPrivilegeTxt extends Sprite implements Disposeable 
    {

        private var _content:TextArea;

        public function VipPrivilegeTxt()
        {
            this.initView();
        }

        private function initView():void
        {
            this._content = ComponentFactory.Instance.creatComponentByStylename("VipPrivilegeLV.propArea");
            addChild(this._content);
        }

        public function set AlertContent(_arg_1:int):void
        {
            this._content.setView(this.getAlerTxt(_arg_1));
            this._content.invalidateViewport();
        }

        private function getAlerTxt(_arg_1:int):MovieImage
        {
            var _local_2:MovieImage = new MovieImage();
            switch (_arg_1)
            {
                case 1:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt1");
                    break;
                case 2:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt2");
                    break;
                case 3:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt3");
                    break;
                case 4:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt4");
                    break;
                case 5:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt5");
                    break;
                case 6:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt6");
                    break;
                case 7:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt7");
                    break;
                case 8:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt8");
                    break;
                case 9:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt9");
                    break;
                case 10:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt10");
                    break;
                case 11:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt11");
                    break;
                case 12:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt12");
                    break;
            };
            return (_local_2);
        }

        public function dispose():void
        {
            if (this._content)
            {
                ObjectUtils.disposeObject(this._content);
                this._content = null;
            };
        }


    }
}//package vip.view

