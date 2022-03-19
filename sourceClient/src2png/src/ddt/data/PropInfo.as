// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.PropInfo

package ddt.data
{
    import ddt.data.goods.ItemTemplateInfo;

    public class PropInfo 
    {

        private var _template:ItemTemplateInfo;
        public var Place:int;
        public var Count:int;

        public function PropInfo(_arg_1:ItemTemplateInfo):void
        {
            this._template = _arg_1;
        }

        public function get Template():ItemTemplateInfo
        {
            return (this._template);
        }

        public function get needEnergy():Number
        {
            return (Number(this._template.Property4));
        }

        public function get needPsychic():int
        {
            return (int(this._template.Property7));
        }

        public function equal(_arg_1:PropInfo):Boolean
        {
            return ((_arg_1.Template == this.Template) && (_arg_1.Place == this.Place));
        }

        public function get TemplateID():int
        {
            return (this._template.TemplateID);
        }


    }
}//package ddt.data

