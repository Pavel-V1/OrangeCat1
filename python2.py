# Инициализация массива A
A = {}
for a1 in [0, 1]:
    for b1 in [0, 1, 2]:
        for a2 in [0, 1]:
            for b2 in [0, 1, 2]:
                for a3 in [0, 1]:
                    A[(a1, b1, a2, b2, a3)] = 0
                    history = [] # История ходов пользователя и ответов машины


def predict(history):
    """ Предсказывает следующее число, написанное человеком. """
    if len(history) < 3:
        return 2 # Первые три раза не угадываем
    a1, b1 = history[-3]
    a2, b2 = history[-2]
    a3, b3 = history[-1]
    count_0 = A[(a2, b2, a3, b3, 0)]
    count_1 = A[(a2, b2, a3, b3, 1)]
    if count_0 > count_1:
        return 0
    elif count_1 > count_0:
        return 1
    else: return 2


def train(a1, b1, a2, b2, a3):
    """ Обучает машину на основе последнего хода. """
    A[(a1, b1, a2, b2, a3)] += 1


def play_game():
    num_trials = 100 # Количество попыток
    correct_predictions = 0
    c = 0
    for i in range(num_trials):
        user_console_input = input("Введите число (0 или 1): ")
        if not user_console_input:
            print("Пожалуйста, введите число.")
            continue
        user_input = int(user_console_input)
        machine_prediction = predict(history)
        if user_input != 0 and user_input != 1:
            print("Пожалуйста, введите корректное число.")
            continue
        print("Предсказание машины:", machine_prediction)
        if machine_prediction != 2:
            c += 1
        if machine_prediction == user_input:
            correct_predictions += 1
        if len(history) >= 2:
            a1, b1 = history[-2]
            a2, b2 = history[-1]
            train(a1, b1, a2, b2, user_input)
        history.append((user_input, machine_prediction))
        if len(history) > 3:
            history.pop(0)
        if c == 0:
            accuracy = 0
        else:
            accuracy = correct_predictions / (c + 1)
        print("Точность:", accuracy)
    print('Количество попыток закончилось, хорошего дня :)')


play_game()