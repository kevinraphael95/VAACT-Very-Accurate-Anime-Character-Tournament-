--[VAACT] Côntrole Hypnotique (Mesmeric Control)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=48642904

function s.initial_effect(c)
	--Traitée comme la carte d'origine
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)
	--Cibler 1 monstre face recto de l'adversaire
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,-800)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup()) or tc:IsImmuneToEffect(e) then return end
	local reset=RESET_EVENT|RESETS_STANDARD
	--Ne peut pas attaquer
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(reset)
	tc:RegisterEffect(e1)
	--Ne peut pas changer sa position de combat
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	tc:RegisterEffect(e2)
	--Ne peut pas activer ses effets
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	tc:RegisterEffect(e3)
	--Ses effets sont annulés
	local e4=e1:Clone()
	e4:SetCode(EFFECT_DISABLE)
	tc:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_DISABLE_EFFECT)
	e5:SetValue(RESET_TURN_SET)
	tc:RegisterEffect(e5)
	--Il perd 800 ATK
	local e6=e1:Clone()
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(-800)
	tc:RegisterEffect(e6)
end
