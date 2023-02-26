import pygame, math
from random import random, randint

class ohjelma():
    def __init__(self, leveys, korkeus):
        pygame.init()

        self.leveys = leveys
        self.korkeus = korkeus
        self.naytto = pygame.display.set_mode((leveys, korkeus))
        pygame.display.set_caption("Avaruusrobotti")

        self.kello = pygame.time.Clock()

        self.robo = robotti(leveys/2, korkeus/2)
        self.pahikset = []
        for i in range(5):
            tyyppi = pahis()
            self.pahikset.append(tyyppi)


        self.rahet = []
        for i in range(2):
            self.rahet.append(kolikko())

        self.hp = 10
        self.pisteet = 0
        self.loppu = False
        self.fontti = pygame.font.SysFont("Arial.txt", 24)
        self.tapahtumat = []

    def update(self):
        self.naytto.fill((13, 17, 24))

        self.tapahtumat = pygame.event.get()

        for tapahtuma in self.tapahtumat:
            if tapahtuma.type == pygame.QUIT:
                exit()

            self.robo.input(tapahtuma)

        if not self.loppu:
            self.robo.liiku()    
        
        self.naytto.blit(self.robo.kuva, (self.robo.x, self.robo.y))

        
        osu = False
        for tyyppi in self.pahikset:
            self.naytto.blit(tyyppi.kuva, (tyyppi.x, tyyppi.y))

            if tyyppi.osuu_robottiin():
                osu = True

            if not self.loppu:
                tyyppi.liiku()

        if osu:
            self.robo.xnopeus = -(self.robo.xnopeus / 3)
            self.robo.ynopeus = -(self.robo.ynopeus / 3)
            self.hp -= 2


        for raha in self.rahet:
            self.naytto.blit(raha.kuva, (raha.x, raha.y))

            if raha.osuu_robottiin():
                raha.randomPos()
                self.pisteet += 1
                self.hp += 1
        

        self.hp = max(0, min(self.hp, 10))
        if self.hp <= 0:
            self.loppu = True

        
        self.piirra_ui()
        pygame.display.flip()
        self.kello.tick(60)


    def piirra_ui(self):

        self.naytto.blit(self.fontti.render(f"pisteet: {self.pisteet}", True, (255, 255, 255)), (0, 5))
        self.naytto.blit(self.fontti.render(f"hp: {self.hp}", True, (255, 255, 255)), (0, 30))

        if self.loppu:
            teksti = self.fontti.render("GAME OVER", True, (255, 0, 0))
            self.naytto.blit(teksti, (self.leveys/2 - teksti.get_width()/2, self.korkeus/2 - teksti.get_height()/2))

            teksti = self.fontti.render(f"pisteet: {self.pisteet}", True, (255, 255, 255))
            self.naytto.blit(teksti, (self.leveys/2 - teksti.get_width()/2, self.korkeus/2 - teksti.get_height()/2 + 25))

            if self.nappi("pelaa uudestaan", self.leveys/2, self.korkeus/2 + 55):
                self.aloita_alusta()


    def nappi(self, teksti: str, xkeski:int, ykeski:int):

        a = self.fontti.render(teksti, True, (0, 0, 0))

        border = 5

        kulma1 = (xkeski - a.get_width()/2 - border, ykeski - a.get_height()/2 - border)
        kulma2 = (xkeski + a.get_width()/2 + border, ykeski + a.get_height()/2 + border)
        pygame.draw.rect(self.naytto, (255, 255, 255), (kulma1[0], kulma1[1], a.get_width() + 2*border, a.get_height() + 2*border))
        self.naytto.blit(a, (xkeski - a.get_width()/2, ykeski - a.get_height()/2))


        painettu = False
        for tapahtuma in self.tapahtumat:
            if tapahtuma.type == pygame.MOUSEBUTTONDOWN:
                x = tapahtuma.pos[0]
                y = tapahtuma.pos[1]

                if (x >= kulma1[0] and x <= kulma2[0]) and (y >= kulma1[1] and y <= kulma2[1]):
                    painettu = True

        return painettu

    def aloita_alusta(self):
        self.hp = 10
        self.pisteet = 0
        self.loppu = False

        for tyyppi in self.pahikset:
            tyyppi.randomPos()

        for raha in self.rahet:
            raha.randomPos()

        self.robo.__init__(self.leveys/2, self.korkeus/2)

class pahis():
    def __init__(self):
        self.kuva = pygame.image.load("hirvio.png")

        self.randomPos()
        

    def randomPos(self):
        self.x = leveys/2 - (self.kuva.get_width() / 2)
        self.y = -self.kuva.get_height()
    
        nopeus = max(1, random() * 5)
        suunta = random() * 2 * math.pi

        self.xnopeus = math.cos(suunta) * nopeus
        self.ynopeus = -math.sin(suunta) * nopeus

    def liiku(self):
        if self.osuu_robottiin():
            self.randomPos()

        self.y += self.ynopeus
        self.x += self.xnopeus

        if self.x <= -self.kuva.get_width():
            self.x = leveys
        elif self.x >= leveys:
            self.x = -self.kuva.get_width()

        if self.y <= -self.kuva.get_height():
            self.y = korkeus
        elif self.y >= korkeus:
            self.y = -self.kuva.get_height()


    def osuu_robottiin(self):
        roboleveys = joo.robo.kuva.get_width()
        robokorkeus = joo.robo.kuva.get_height()

        osuu_x = self.x <= joo.robo.x + roboleveys and self.x + self.kuva.get_width() >= joo.robo.x
        osuu_y = self.y <= joo.robo.y + robokorkeus and self.y + self.kuva.get_height() >= joo.robo.y
        #print(f"{osuu_x}, {osuu_y}")

        return osuu_x and osuu_y

class kolikko():
    def __init__(self):
        self.kuva = pygame.image.load("kolikko.png")
        self.randomPos()

    def randomPos(self):
        self.x = randint(1, leveys - self.kuva.get_width())
        self.y = randint(1, korkeus - self.kuva.get_height())

    def osuu_robottiin(self):
        roboleveys = joo.robo.kuva.get_width()
        robokorkeus = joo.robo.kuva.get_height()

        osuu_x = self.x <= joo.robo.x + roboleveys and self.x + self.kuva.get_width() >= joo.robo.x
        osuu_y = self.y <= joo.robo.y + robokorkeus and self.y + self.kuva.get_height() >= joo.robo.y
        #print(f"{osuu_x}, {osuu_y}")

        return osuu_x and osuu_y

class robotti():
    def __init__(self, x, y):
        self.kuva = pygame.image.load("robo.png")
        self.leveys = self.kuva.get_width()
        self.korkeus = self.kuva.get_height()
        self.x = x
        self.y = y
        self.xnopeus = 0
        self.ynopeus = 0
        self.ylos = False
        self.alas = False
        self.oikea = False
        self.vasen = False

    def input(self, tapahtuma):
        if tapahtuma.type == pygame.KEYDOWN:
            if tapahtuma.key == pygame.K_a:
                self.vasen = True
                self.oikea = False
            if tapahtuma.key == pygame.K_d:
                self.oikea = True
                self.vasen = False
            if tapahtuma.key == pygame.K_w:
                self.ylos = True
                self.alas = False
            if tapahtuma.key == pygame.K_s:
                self.alas = True
                self.ylos = False

        if tapahtuma.type == pygame.KEYUP:
            if tapahtuma.key == pygame.K_a:
                self.vasen = False
            if tapahtuma.key == pygame.K_d:
                self.oikea = False
            if tapahtuma.key == pygame.K_w:
                self.ylos = False
            if tapahtuma.key == pygame.K_s:
                self.alas = False

    def liiku(self):
        if self.oikea:
            self.xnopeus += 0.5
        if self.vasen:
            self.xnopeus -= 0.5
        if self.ylos:
            self.ynopeus -= 0.5
        if self.alas:
            self.ynopeus += 0.5

        self.xnopeus = max(-15, min(self.xnopeus, 15))
        self.ynopeus = max(-15, min(self.ynopeus, 15))

        self.x += self.xnopeus
        self.y += self.ynopeus

        if self.x <= -self.leveys:
            self.x = leveys
        elif self.x >= leveys:
            self.x = -self.leveys

        if self.y <= -self.korkeus:
            self.y = korkeus
        elif self.y >= korkeus:
            self.y = -self.korkeus


leveys, korkeus = 640, 480
joo = ohjelma(leveys, korkeus)

while True:
    joo.update()