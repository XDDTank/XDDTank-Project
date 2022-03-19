// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.SoulPropCell

package game.view.prop
{
    import ddt.view.tips.ToolPropInfo;
    import game.GameManager;

    public class SoulPropCell extends PropCell 
    {

        public function SoulPropCell()
        {
            this.enabled = false;
            _tipInfo.valueType = ToolPropInfo.Psychic;
            this.setGrayFilter();
        }

        override public function set enabled(_arg_1:Boolean):void
        {
            if ((!(_arg_1)))
            {
                super.enabled = _arg_1;
            }
            else
            {
                if (((GameManager.Instance.Current.currentLiving.isBoss) && (((((info.TemplateID == 10016) || (info.TemplateID == 10017)) || (info.TemplateID == 10018)) || (info.TemplateID == 10015)) || (info.TemplateID == 10022))))
                {
                    super.enabled = false;
                }
                else
                {
                    super.enabled = _arg_1;
                };
            };
        }

        override public function setPossiton(_arg_1:int, _arg_2:int):void
        {
            super.setPossiton(_arg_1, _arg_2);
            this.x = _x;
            this.y = _y;
        }


    }
}//package game.view.prop

